import 'package:frontend/models/product.dart';

class Category {
  late String name;
  List<Product>? products;

  Category({required this.name, this.products});

}