import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/employee_screens/active_assignment/fetch_products_stage.dart';
import 'package:frontend/employee_screens/active_assignment/preparing_for_approval_stage.dart';
import 'package:frontend/employee_screens/active_assignment/waiting_on_customer_to_approve_stage.dart';
import 'package:frontend/employee_screens/active_assignment/ack_removal_and_scan.dart';
import 'package:frontend/main.dart';



class EmployeeCart extends StatefulWidget {

  const EmployeeCart({super.key});

  @override
  State<EmployeeCart> createState() => _EmployeeCart();
}

class _EmployeeCart extends State<EmployeeCart>
    with SingleTickerProviderStateMixin{

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getCart();
  }

  Future<void> getCart() async {
    setState(() {
      _loading = true;
    });
    await cartService.getCart(false);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? loadedWidget;
    switch(cartService.state) {
      case "Gathering Items":
        loadedWidget = FetchProductStage();
        break;
      case "Preparing For Approval":
        loadedWidget = PreparingForApprovalStage();
        break;
      case "Pending Approval":
        loadedWidget = WaitingOnCustomerToApproveStage();
        break;
      case "Removal":
        loadedWidget = WaitingOnCustomerToApproveStage();
        break;
      case "Approved":
        loadedWidget = AcknowledgeRemovalAndScan();
        break;
      default:
        loadedWidget = const Text("Error");
    }
    return
        _loading 
            ? Center(child: CircularProgressIndicator())
            : loadedWidget
    ;
  }
}