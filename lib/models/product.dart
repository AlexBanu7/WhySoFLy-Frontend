class Product {
  int id;
  int marketId;
  int categoryId;
  String name;
  double volumePerQuantity; // volume of one item/one kilo
  double pricePerQuantity; // price for one item/one kilo

  Product({
    required this.id,
    required this.marketId,
    required this.categoryId,
    required this.name,
    required this.volumePerQuantity,
    required this.pricePerQuantity
  });
}