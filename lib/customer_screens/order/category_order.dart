import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/order/exandable_category.dart';
import 'package:frontend/customer_screens/order/products_accordion.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/order/categories_accordion.dart';
import 'package:frontend/models/market.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class CategoryOrderPage extends StatefulWidget {

  late Category category;
  late Market market;

  CategoryOrderPage({super.key, arguments}){
    if (arguments is List){
      category = arguments[0];
      market = arguments[1];
    } else {
      category = Category(id: -1, name: "Unknown", products: []);
    }
  }

  @override
  State<CategoryOrderPage> createState() => _CategoryOrderPage();
}

class _CategoryOrderPage extends State<CategoryOrderPage>
    with SingleTickerProviderStateMixin{

  int categoriesExpandedIndex = -1;
  int productsExpandedIndex = -1;
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void updatedExpansionIndexes(_categoriesExpandedIndex, _productsExpandedIndex){
    setState(() {
      categoriesExpandedIndex = _categoriesExpandedIndex;
      productsExpandedIndex = _productsExpandedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(widget.category.name),
      drawer: const CustomDrawer(),
      body: widget.category.products.length == 0 ?
      const Center(
        child: Text("No products available in this category",
          style: TextStyle(
              fontSize: 20,
            fontStyle: FontStyle.italic
          ),
          textAlign: TextAlign.center,
        )
      ):
      ProductsAccordion(
          category: widget.category,
      )
    );
  }
}
