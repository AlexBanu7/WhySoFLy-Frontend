import 'package:flutter/material.dart';

class Product {
  int id;
  int marketId;
  int categoryId;
  bool soldByWeight;
  String name;
  String? description;
  double volumePerQuantity; // volume of one item/one kilo
  double pricePerQuantity; // price for one item/one kilo
  String? image;

  Product({
    required this.id,
    required this.marketId,
    required this.categoryId,
    required this.soldByWeight,
    required this.name,
    required this.volumePerQuantity,
    required this.pricePerQuantity,
    this.image,
    this.description
  });
}