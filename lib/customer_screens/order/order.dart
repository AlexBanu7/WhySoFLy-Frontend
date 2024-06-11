import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/order/exandable_category.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/order/categories_accordion.dart';
import 'package:frontend/models/market.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class OrderPage extends StatefulWidget {

  late Market market;

  OrderPage({super.key, arguments}){
    if (arguments is Market){
      market = arguments;
    } else {
      market = Market(id: -1, name: "Unknown", location: const LatLng(0,0));
    }
  }

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage>
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
    print("settings state at indexes ${_categoriesExpandedIndex} and ${_productsExpandedIndex}");
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
      appBar: CustomAppBar("Ordering at ${widget.market.name}"),
      drawer: const CustomDrawer(),
      body:
        PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/first_categories.jpg"),
                  fit: BoxFit.cover,
                    opacity: 0.5
                ),
              ),
              child: CategoriesAccordion(
                  market: widget.market,
                  categoriesExpandedIndex: categoriesExpandedIndex,
                  productsExpandedIndex: productsExpandedIndex,
                  updatedExpansionIndexes: updatedExpansionIndexes,
                  pageNumber: 0,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/second_categories.jpg"),
                  fit: BoxFit.cover,
                    opacity: 0.5
                ),
              ),
              child: CategoriesAccordion(
                  market: widget.market,
                  categoriesExpandedIndex: categoriesExpandedIndex,
                  productsExpandedIndex: productsExpandedIndex,
                  updatedExpansionIndexes: updatedExpansionIndexes,
                  pageNumber: 1,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/third_categories.jpg"),
                  fit: BoxFit.cover,
                    opacity: 0.5
                ),
              ),
              child: CategoriesAccordion(
                  market: widget.market,
                  categoriesExpandedIndex: categoriesExpandedIndex,
                  productsExpandedIndex: productsExpandedIndex,
                  updatedExpansionIndexes: updatedExpansionIndexes,
                  pageNumber: 2,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/fourth_categories.jpg"),
                  fit: BoxFit.cover,
                    opacity: 0.5
                ),
              ),
              child: CategoriesAccordion(
                  market: widget.market,
                  categoriesExpandedIndex: categoriesExpandedIndex,
                  productsExpandedIndex: productsExpandedIndex,
                  updatedExpansionIndexes: updatedExpansionIndexes,
                  pageNumber: 3,
              ),
            ),
          ],
        )
    );
  }
}
