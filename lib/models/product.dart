class Product {
  int id;
  String name;
  double volumePerQuantity; // volume of one item/one kilo
  double pricePerQuantity; // price for one item/one kilo

  Product({required this.id, required this.name, required this.volumePerQuantity, required this.pricePerQuantity});
}