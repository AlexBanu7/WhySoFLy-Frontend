import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/main.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class EmptyCart extends StatefulWidget {
  const EmptyCart({super.key});

  @override
  State<EmptyCart> createState() => _EmptyCart();
}

class _EmptyCart extends State<EmptyCart>
    with SingleTickerProviderStateMixin{

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Transform.scale(
            scale: 0.5,
            child: Image.asset(
              'assets/images/question-man.png', // Path to your image
              fit: BoxFit.cover,
            ),
          ),
          const Text("Looking for products? Might want to add them first.")
        ]
      )
    );
  }
}