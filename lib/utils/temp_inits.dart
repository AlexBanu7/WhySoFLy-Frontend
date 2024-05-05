import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';

class TempInits {
  List<Market> markets = [];
  List<Product> products = [];
  List<Category> categories = [];

  TempInits () {
    markets = [Market(
      id: Random().nextInt(9999),
      name: "Fake Lidl",
      location: LatLng(45.7489, 21.23)
    )];
    Market market = markets[0];
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
      volumePerQuantity: 1.5,
      pricePerQuantity: 4.99
    )];
  }
}