class CartItem {
  int id;
  bool accepted;
  int productId;
  String name;
  num quantity; // number of items/kg
  num volume;
  num price;
  String? image;

  CartItem({
    required this.id,
    required this.accepted,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.volume,
    required this.price,
    this.image,
  });
}