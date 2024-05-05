import 'package:frontend/models/product.dart';

class Category {
  int id;
  late String name;
  List<Product>? products;

  Category({required this.id, required this.name, this.products});

}