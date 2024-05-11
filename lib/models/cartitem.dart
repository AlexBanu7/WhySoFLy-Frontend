class CartItem {
  int id;
  int productId;
  String name;
  num quantity; // number of items/kg
  double volume;
  double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.volume,
    required this.price
  });
}