import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/cart/pending_approval_cart.dart';
import 'package:frontend/customer_screens/cart/qr_code_cart.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  int counter = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getCart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getCart();
    }
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("Your Shopping Cart"),
      drawer: const CustomDrawer(),
      body: const QRCodeCart()
      // _loading
      //     ? const Center(child: CircularProgressIndicator())
      //     : cartService.state == "New" || cartService.state == "Gathering Items"
      //       ? InProgressCart()
      //       : cartService.state == "Pending Approval"
      //         ? PendingApprovalCart() // NOT YET IMPLEMENTED
      //         : cartService.state == "Approved"
      //           ?
      //             : cartService.cartitems.isNotEmpty
      //             ? FilledCart(onUpdate: () {
      //                 setState(() {
      //                   counter++;
      //                 });
      //               })
      //             : const EmptyCart()
    );
  }
}