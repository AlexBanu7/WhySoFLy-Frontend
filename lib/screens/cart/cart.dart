import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/cart/empty_cart.dart';
import 'package:frontend/screens/cart/filled_cart.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPage();
}

class _CartPage extends State<CartPage>
    with SingleTickerProviderStateMixin{

  int counter = 0;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("Your Shopping Cart"),
      drawer: const CustomDrawer(),
      body: cartService.cartitems.isNotEmpty ? FilledCart(onUpdate: () {
        setState(() {
          counter++;
        });
      }) : const EmptyCart()
    );
  }
}