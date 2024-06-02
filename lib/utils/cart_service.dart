import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';
import 'package:http/http.dart';

import '../models/product.dart';

class CartService {

  int? marketId;
  double volume = 300; // in liters
  List<CartItem> cartitems = [];
  int? backendId;
  String? state;
  int? employeeId;

  void clearCart() {
    // TODO: Use when an order has been completed
    // clears the cart
    marketId = null;
    cartitems = [];
    backendId = null;
    state = null;
    employeeId = null;
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
    // If cart has a backendId, add in backend instead
    print(backendId);
    if (backendId != null) {
      print("Adding to backend cart");
      addToBackendCart(product, quantity);
    } else {
      print("Adding to local cart");
      if (!cartitems.any((cartitem) => cartitem.productId == product.id)) {
        CartItem cartItem = CartItem(
            id:Random().nextInt(9999),
            productId: product.id,
            name: product.name,
            quantity: quantity,
            volume: quantity * product.volumePerQuantity,
            price: quantity * product.pricePerQuantity,
            accepted: false
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
  }

  Future<void> addToBackendCart(Product product, num quantity) async {
    Map<String, dynamic> data = {
      "name": product.name,
      "productId": product.id,
      "quantity": quantity,
      "volume": quantity * product.volumePerQuantity,
      "price": quantity * product.pricePerQuantity,
      "accepted": true,
      "cartId": backendId,
    };

    var response = await session_requests.post(
      '/api/Cart/CartItem',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      session_requests.sendMessage("Add To Cart");
    }
    else {
      throw Exception("Failed to add to cart");
    }
  }

  void setAccepted(CartItem cartitem, bool accepted) {
    int existingIndex = cartitems.indexWhere((element) => element.id == cartitem.id);
    cartitems[existingIndex].accepted = accepted;
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

  Future<void> confirmOrder() async {
    Map<String, dynamic> data = {
      "customerEmail": currentUser!.email.toString(),
      "marketId": marketId.toString(),
      "cartItems": cartitems.map((cartitem) => {
        "name": cartitem.name,
        "quantity": cartitem.quantity,
        "volume": cartitem.volume,
        "price": cartitem.price,
        "productId": cartitem.productId.toString(),
        "accepted": !cartitem.accepted
      }).toList()
    };

    var response = await session_requests.post(
      '/api/Cart',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      getCart(true);
    }
    else {
      throw Exception("Failed to confirm order");
    }
  }

  Future<void> getCart(bool forCustomer) async {
    if (currentUser == null) {
      return;
    }
    Response response;
    if (forCustomer){
      response = await session_requests.post(
          '/api/Cart/ByCustomerEmail',
          json.encode(currentUser?.email)
      );
    } else {
      response = await session_requests.post(
          '/api/Cart/ByEmployeeId',
          json.encode(currentUser?.employee?.id)
      );
    }

    print(response.statusCode);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("Got cart");
      clearCart();
      var body = json.decode(response.body);
      print(body);
      backendId = body['id'];
      state = body['state'];
      employeeId = body['employeeId'];
      marketId = body['marketId'];
      List<CartItem> fetchedCartItems = [];
      for (var cartitem in body['cartItems']) {
        CartItem fetchedCartItem = CartItem(
          id: cartitem['id'],
          productId: cartitem['productId'],
          name: cartitem['name'],
          quantity: cartitem['quantity'],
          volume: cartitem['volume'],
          price: cartitem['price'],
          accepted: cartitem['accepted'],
          image: cartitem['image']
        );
        fetchedCartItems.add(fetchedCartItem);
      }
      cartitems = fetchedCartItems;
    }
    else if (response.statusCode != 404) {
      throw Exception("Failed to get cart");
    }
  }

  Future<void> patchCartItemsPhotos(Map<int, File?> photos) async {
    Map<String, dynamic> data = {
      "cartId": backendId,
      "cartItems": photos.entries.map((entry) => {
        "id": entry.key,
        "image": base64Encode(entry.value!.readAsBytesSync())
      }).toList()
    };

    var response = await session_requests.put(
      '/api/Cart/AttachPhotos',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
    }
    else {
      throw Exception("Failed to attach photos to cart items");
    }
  }
}