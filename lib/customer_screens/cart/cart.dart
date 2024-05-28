import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/cart/pending_approval_cart.dart';
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
    await cartService.getCart();
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
      body:
      _loading
          ? const Center(child: CircularProgressIndicator())
          : cartService.state == "Gathering Items"
            ? InProgressCart()
            : cartService.state == "Pending Approval"
              ? PendingApprovalCart()
              : cartService.cartitems.isNotEmpty
                ? FilledCart(onUpdate: () {
                    setState(() {
                      counter++;
                    });
                  })
                : const EmptyCart()
    );
  }
}