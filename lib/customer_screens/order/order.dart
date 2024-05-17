import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/order/categories_accordion.dart';

import '../../models/category.dart';
import '../../models/product.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class OrderPage extends StatefulWidget {

  late String marketName;

  OrderPage({super.key, arguments}){
    if (arguments is String){
      marketName = arguments;
    } else {
      marketName = "an Unnamed Market";
    }
  }

  @override
  State<OrderPage> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage>
    with SingleTickerProviderStateMixin{

  int categoriesExpandedIndex = -1;
  int productsExpandedIndex = -1;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("Ordering at ${widget.marketName}"),
      drawer: const CustomDrawer(),
      body: CategoriesAccordion(
        categoriesExpandedIndex: categoriesExpandedIndex,
        productsExpandedIndex: productsExpandedIndex,
        updatedExpansionIndexes: updatedExpansionIndexes
      )
    );
  }
}
