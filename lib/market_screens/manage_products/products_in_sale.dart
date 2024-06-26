import 'package:flutter/material.dart';
import 'package:frontend/market_screens/manage_products/categories_accordion.dart';
import 'package:frontend/main.dart';


class ProductsInSaleTab extends StatefulWidget {
  const ProductsInSaleTab({super.key});

  @override
  State<ProductsInSaleTab> createState() => _ProductsInSaleTab();
}

class _ProductsInSaleTab extends State<ProductsInSaleTab>
    with SingleTickerProviderStateMixin{

  int categoriesExpandedIndex = -1;
  int productsExpandedIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  void updatedExpansionIndexes(_categoriesExpandedIndex, _productsExpandedIndex){
    setState(() {
      categoriesExpandedIndex = _categoriesExpandedIndex;
      productsExpandedIndex = _productsExpandedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoriesAccordion(
        market: currentUser?.market,
        categoriesExpandedIndex: categoriesExpandedIndex,
        productsExpandedIndex: productsExpandedIndex,
        updatedExpansionIndexes: updatedExpansionIndexes,
    );
  }
}