import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/order/products_accordion.dart';

import 'package:frontend/models/category.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/models/product.dart';

class CategoriesAccordion extends StatefulWidget {

  final Market market;
  final int categoriesExpandedIndex;
  final int productsExpandedIndex;
  final void Function(int, int) updatedExpansionIndexes;

  const CategoriesAccordion({
    super.key,
    required this.categoriesExpandedIndex,
    required this.productsExpandedIndex,
    required this.updatedExpansionIndexes,
    required this.market
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
      '/api/Category?market_id=${widget.market.id}'
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
    return _loading?
      const Center(child: CircularProgressIndicator())
        :
      Accordion(
        headerBackgroundColorOpened: Colors.transparent,
        headerBorderWidth: 3,
        headerBackgroundColor: Colors.transparent,
        contentBackgroundColor: Colors.transparent,
        contentBorderWidth: 0,
        contentHorizontalPadding: 0,
        scaleWhenAnimating: false,
        openAndCloseAnimation: true,
        paddingBetweenClosedSections: 30,
        paddingBetweenOpenSections: 30,
        headerPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        rightIcon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
        children: _populate_categories_accordion()
      );
  }

  List<AccordionSection> _populate_categories_accordion() {
    List<AccordionSection> categories_to_sections = [];
    for (var entry in categories.asMap().entries) {
      int index = entry.key;
      Category category = entry.value;
      categories_to_sections.add(
        AccordionSection(
          headerBorderColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          headerBorderColorOpened: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
          isOpen: index == widget.categoriesExpandedIndex,
          contentVerticalPadding: 0,
          header: Text(category.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: ProductsAccordion(
              market: widget.market,
              category: category,
              productsExpandedIndex: widget.productsExpandedIndex,
              categoriesExpandedIndex: index,
              updatedExpansionIndexes: widget.updatedExpansionIndexes
          )
        ),
      );
    }
    return categories_to_sections;
  }
}
