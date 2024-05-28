import 'dart:core';

import 'package:flutter/material.dart';

class PendingApprovalCart extends StatefulWidget {
  const PendingApprovalCart({super.key});

  @override
  State<PendingApprovalCart> createState() => _PendingApprovalCart();
}

class _PendingApprovalCart extends State<PendingApprovalCart>
    with SingleTickerProviderStateMixin{


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