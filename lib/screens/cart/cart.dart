import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Your Shopping Cart"),
      drawer: CustomDrawer(),
      body: cartService.cartitems.isNotEmpty ? const FilledCart() : const EmptyCart()
    );
  }
}