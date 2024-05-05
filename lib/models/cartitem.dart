class CartItem {
  int id;
  String name;
  double quantity; // number of items/kg
  double volume;
  double price;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.volume,
    required this.price
  });
}