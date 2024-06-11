import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/order/exandable_category.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/order/products_accordion.dart';

import 'package:frontend/models/category.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/models/product.dart';

class CategoriesAccordion extends StatefulWidget {

  final Market? market;
  final int categoriesExpandedIndex;
  final int productsExpandedIndex;
  final void Function(int, int) updatedExpansionIndexes;
  final int pageNumber;

  const CategoriesAccordion({
    super.key,
    required this.categoriesExpandedIndex,
    required this.productsExpandedIndex,
    required this.updatedExpansionIndexes,
    required this.market, required this.pageNumber
  });

  @override
  State<CategoriesAccordion> createState() => _CategoriesAccordion();
}

class _CategoriesAccordion extends State<CategoriesAccordion>
    with SingleTickerProviderStateMixin{

  bool _loading = true; // Track loading state
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    getCategories().then((value) {
      setState(() {
        categories = value;
        _loading = false;
      });
    });
  }

  Future<List<Category>> getCategories() async {
    var response = await session_requests.get(
      '/api/Category?market_id=${widget.market?.id}'
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Category> categories = [];
      var body = json.decode(response.body);
      for (var category in body) {
        Category newCategory = Category(
          id: category['id'],
          name: category['name'],
          products: []
        );
        for (var product in category["products"]??[]) {
          newCategory.products.add(Product(
            id: product['id'],
            name: product['name'],
            marketId: product['marketId'],
            categoryId: product['categoryId'],
            soldByWeight: product['soldByWeight'],
            volumePerQuantity: double.tryParse(product['volumePerQuantity'].toString())??0.0,
            pricePerQuantity: double.tryParse(product['pricePerQuantity'].toString())?? 0.0,
          ));
        }
        categories.add(newCategory);
      }
      return categories;
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong! Please refresh the page'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: _populate_categories_column()
            ),
          ),
        );
  }
  
  List<Widget> _populate_categories_column() {
    List<Widget> categories_to_columns = [];
    for (var entry in categories.asMap().entries) {
      int index = entry.key;
      if (index <= (widget.pageNumber + 1) * categories.length / 4 && index >= categories.length * widget.pageNumber / 4 ) {
        Category category = entry.value;
        categories_to_columns.add(
            Padding(
              padding: EdgeInsets.all(20),
              child: ExpandableCategory(category: category, leftSided: widget.pageNumber % 2 == 0),
            )
        );
      }
    }
    return categories_to_columns;
  }
}
