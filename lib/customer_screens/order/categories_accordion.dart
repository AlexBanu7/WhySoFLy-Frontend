import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/order/products_accordion.dart';

import 'package:frontend/models/category.dart';

class CategoriesAccordion extends StatefulWidget {

  final int categoriesExpandedIndex;
  final int productsExpandedIndex;
  final void Function(int, int) updatedExpansionIndexes;

  const CategoriesAccordion({
    super.key,
    required this.categoriesExpandedIndex,
    required this.productsExpandedIndex,
    required this.updatedExpansionIndexes
  });

  @override
  State<CategoriesAccordion> createState() => _CategoriesAccordion();
}

class _CategoriesAccordion extends State<CategoriesAccordion>
    with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerBackgroundColorOpened: Colors.transparent,
      headerBorderColor: Colors.lightGreen,
      headerBorderColorOpened: Colors.lightGreen,
      headerBorderWidth: 3,
      headerBackgroundColor: Colors.transparent,
      contentBackgroundColor: Colors.transparent,
      contentBorderWidth: 0,
      contentHorizontalPadding: 0,
      scaleWhenAnimating: false,
      openAndCloseAnimation: true,
      headerPadding:
      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      rightIcon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
      children: _populate_categories_accordion()
    );
  }

  List<AccordionSection> _populate_categories_accordion() {
    List<AccordionSection> categories_to_sections = [];
    for (var entry in tempInits.categories.asMap().entries) {
      int index = entry.key;
      Category category = entry.value;
      categories_to_sections.add(
        AccordionSection(
          isOpen: index == widget.categoriesExpandedIndex,
          contentVerticalPadding: 0,
          header: Text(category.name),
          content: ProductsAccordion(
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
