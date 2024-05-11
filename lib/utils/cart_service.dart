import 'dart:math';

import 'package:frontend/models/cartitem.dart';

import '../models/product.dart';

class CartService {

  int? marketId;
  double volume = 300; // in liters
  List<CartItem> cartitems = [CartItem(
      id:1,
      productId: 132,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  )];

  CartService(_marketId) {
    marketId = _marketId;
  }

  void clearCart() {
    // clears the cart
    marketId = null;
    cartitems = [];
  }

  void addToCart(Product product, num quantity) {
    // Validate same market ordering
    if (product.marketId != marketId) {
      throw Exception("Not the same market! Clear cart first");
    }
    // Ensure Volume is not exceeded
    if (computeVolumeLeft() - quantity * product.volumePerQuantity < 0){
      throw Exception("Cannot add the item! Volume will be exceeded");
    }
    // Add to cart
    if (!cartitems.any((cartitem) => cartitem.productId == product.id)) {
      CartItem cartItem = CartItem(
          id:Random().nextInt(9999),
          productId: product.id,
          name: product.name,
          quantity: quantity,
          volume: quantity * product.volumePerQuantity,
          price: quantity * product.pricePerQuantity
      );
      cartitems.add(cartItem);
    } else {
      int existingIndex = cartitems.indexWhere((cartitem) => cartitem.productId == product.id);
      CartItem cartItemToModify = cartitems[existingIndex];
      cartItemToModify.quantity += quantity;
      cartItemToModify.volume += quantity * product.volumePerQuantity;
      cartItemToModify.price += quantity * product.pricePerQuantity;
    }
  }
  
  void removeFromCart(CartItem cartitem) {
    cartitems.removeWhere((element) => element.id == cartitem.id);
    print("Removed ${cartitem.name} from cart");
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (var cartitem in cartitems){
      totalPrice += cartitem.price;
    }
    return totalPrice;
  }

  double computeVolumeLeft() {
    // TODO: Get from API
    double volumeLeft = volume;
    for (var cartitem in cartitems){
      volumeLeft -= cartitem.volume;
    }
    return volumeLeft;
  }

}