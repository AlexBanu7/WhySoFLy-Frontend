import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/models/employee.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:frontend/models/category.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/models/product.dart';

class TempInits {
  List<Market> markets = [];
  List<Product> products = [];
  List<Category> categories = [];
  List<Employee> employees = [];

  TempInits () {
    markets = [Market(
      id: Random().nextInt(9999),
      name: "Fake Lidl",
      location: const LatLng(45.7489, 21.23)
    )];
    Market market = markets[0];
    employees = [Employee(
        id: Random().nextInt(9999),
        name: "Alex Banu",
        status: "idle",
        ordersDone: 30,
        marketId: market.id)
    ];
    categories = [Category(
      id: Random().nextInt(9999),
      name: "Vegetables",
    )];
    Category category = categories[0];
    products = [Product(
      id: Random().nextInt(9999),
      name: "Potatoes",
      marketId: market.id,
      categoryId: category.id,
      soldByWeight: 1,
      volumePerQuantity: 1.5,
      pricePerQuantity: 4.99,
      image: 'assets/images/home-footer.png'
    )];
    category.products = products;
  }
}