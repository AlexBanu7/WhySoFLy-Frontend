import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/employee_screens/active_assignment/fetch_products_stage.dart';
import 'package:frontend/employee_screens/active_assignment/preparing_for_approval_stage.dart';
import 'package:frontend/employee_screens/active_assignment/waiting_on_customer_to_approve_stage.dart';
import 'package:frontend/main.dart';


class EmployeeCart extends StatefulWidget {
  const EmployeeCart({super.key});

  @override
  State<EmployeeCart> createState() => _EmployeeCart();
}

class _EmployeeCart extends State<EmployeeCart>
    with SingleTickerProviderStateMixin{

  bool _loading = true;

  void updateWidget() {
    getCart();
  }

  @override
  void initState() {
    super.initState();
    getCart();
  }

  Future<void> getCart() async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(const Duration(seconds: 2), () async {
      await cartService.getCart(false);
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        _loading 
            ? Center(child: CircularProgressIndicator())
            : cartService.state != "Gathering Items"
                ? FetchProductStage(updateWidget: updateWidget)
                : cartService.state != "Preparing For Approval"
                    ? PreparingForApprovalStage(updateWidget: updateWidget)
                    : WaitingOnCustomerToApproveStage()
    ;
  }
}