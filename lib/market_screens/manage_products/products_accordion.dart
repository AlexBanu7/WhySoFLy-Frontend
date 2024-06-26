import 'dart:convert';
import 'dart:core';

import 'package:accordion/accordion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/market_screens/manage_products/product_details_dialog.dart';

import 'package:frontend/models/category.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';


class ProductsAccordion extends StatefulWidget {

  final Category category;
  final int productsExpandedIndex;
  final int categoriesExpandedIndex;
  final void Function(int, int) updatedExpansionIndexes;
  final Market? market;

  const ProductsAccordion({
    super.key,
    required this.category,
    required this.categoriesExpandedIndex,
    required this.productsExpandedIndex,
    required this.updatedExpansionIndexes,
    required this.market
  });

  @override
  State<ProductsAccordion> createState() => _ProductsAccordion();
}

class _ProductsAccordion extends State<ProductsAccordion>
    with SingleTickerProviderStateMixin{

  int tempIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  Future<void> onConfirmRemoval() async {
    print(widget.category.products[tempIndex].id);
    print(tempIndex);
    var response = await session_requests.delete(
      '/api/Product/${widget.category.products[tempIndex].id}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse the JSON response body into a Dart object
      const snackBar = SnackBar(
        content: Text('Product successfully removed!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      widget.updatedExpansionIndexes(widget.categoriesExpandedIndex, -1);
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Accordion(
      headerBackgroundColorOpened: Colors.transparent,
      headerBorderColor: Colors.lightBlueAccent,
      headerBorderColorOpened: Colors.lightBlueAccent,
      headerBorderWidth: 2,
      headerBackgroundColor: Colors.transparent,
      contentBackgroundColor: Colors.transparent,
      contentBorderWidth: 2,
      contentBorderColor: Colors.lightBlueAccent,
      contentVerticalPadding: 10,
      contentHorizontalPadding: 70,
      contentBorderRadius: 30,
      scaleWhenAnimating: false,
      openAndCloseAnimation: true,
      headerPadding:
      const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      rightIcon: null,
      children: _populate_products_accordion(widget.category)
    );
  }

  List<AccordionSection> _populate_products_accordion(Category category) {
    List<AccordionSection> products_to_sections = [];
    for (var entry in (category.products).asMap().entries) {
      int index = entry.key;
      Product product = entry.value;
      if (product.marketId != widget.market?.id) {
        continue;
      }
      products_to_sections.add(
        AccordionSection(
          isOpen: widget.productsExpandedIndex == index,
          header: Text(product.name),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.redAccent,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          tempIndex = index;
                          return ConfirmationDialog(
                              title: 'Are you sure you want remove this product?',
                              onConfirm: onConfirmRemoval
                          );
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Remove',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orangeAccent,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      widget.updatedExpansionIndexes(widget.categoriesExpandedIndex, index);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProductDetailsDialog(
                            product: product,
                          );
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'See Details',
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return products_to_sections;
  }
}
