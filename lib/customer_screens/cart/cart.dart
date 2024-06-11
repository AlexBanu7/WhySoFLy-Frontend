import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/cart/pending_approval_cart.dart';
import 'package:frontend/customer_screens/cart/qr_code_cart.dart';
import 'package:frontend/customer_screens/cart/removal_cart.dart';
import 'package:frontend/main.dart';
import 'package:frontend/customer_screens/cart/empty_cart.dart';
import 'package:frontend/customer_screens/cart/filled_cart.dart';

import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_drawer.dart';
import 'in_progress_cart.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPage();
}

class _CartPage extends State<CartPage>
    with SingleTickerProviderStateMixin{

  int counter = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getCart();
  }

  Future<void> getCart() async {
    print("Getting cart");
    setState(() {
      _loading = true;
    });
    await cartService.getCart(true);
    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    Widget? loadedWidget;
    switch(cartService.state) {
      case "Gathering Items":
        loadedWidget = InProgressCart(withAddMore: true);
        break;
      case "New":
        loadedWidget = InProgressCart(withAddMore: true);
        break;
      case "Preparing For Approval":
        loadedWidget = InProgressCart(withAddMore: false);
        break;
      case "Pending Approval":
        loadedWidget = PendingApprovalCart();
        break;
      case "Removal":
        loadedWidget = RemovalCart();
        break;
      case "Approved":
        loadedWidget = QRCodeCart();
        break;
      case "Finished":
        loadedWidget = Text("Thank you!"); // TODO: Implement!
        break;
      default:
        switch(cartService.cartitems.isNotEmpty) {
          case true:
            loadedWidget = FilledCart(onUpdate: () {
              setState(() {
                counter++;
              });
            });
            break;
          case false:
            loadedWidget = const EmptyCart();
            break;
        }
        break;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("Your Shopping Cart"),
      drawer: const CustomDrawer(),
      body:
      _loading
          ? const Center(child: CircularProgressIndicator())
          : loadedWidget
    );
  }
}