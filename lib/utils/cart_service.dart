import 'package:frontend/models/cartitem.dart';

import '../models/product.dart';

class CartService {

  List<CartItem> cartitems = [CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  ),CartItem(
      id:1,
      name: "Potato",
      quantity: 1.2,
      volume: 60,
      price: 5.99
  )];

  CartService() {
    print("Created a cart!");
    // Create Cart for currentUser
  }

  void clearCart() {
    print("Cleared the cart!");
    // clears the cart
  }

  void addToCart(CartItem cartitem) {
    cartitems.add(cartitem);
    print("Added ${cartitem.name} to cart");
    // Adds to cart
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
    double volumeLeft = 300; // in litters
    for (var cartitem in cartitems){
      volumeLeft -= cartitem.volume;
    }
    return volumeLeft;
  }

}