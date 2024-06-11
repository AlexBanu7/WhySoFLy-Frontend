import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/employee_screens/active_assignment/cart.dart';
import 'package:frontend/employee_screens/active_assignment/pause.dart';
import 'package:frontend/employee_screens/active_assignment/qr_scan.dart';
import 'package:frontend/employee_screens/active_assignment/resume.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_drawer.dart';


class ActiveAssignmentPage extends StatefulWidget {
  const ActiveAssignmentPage({super.key});

  @override
  State<ActiveAssignmentPage> createState() => _ActiveAssignmentPage();
}

class _ActiveAssignmentPage extends State<ActiveAssignmentPage>
    with SingleTickerProviderStateMixin{

  bool _loading = true;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    updateInfo();
  }

  Future<void> updateInfo () async {
    setState(() {
      _loading = true;
    });
    await Future.delayed(const Duration(seconds: 1), () async {
      var response = await session_requests.post(
        '/identity/userInfo',
        json.encode(currentUser?.email),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        // Create User from Request body
        currentUser = User(
          email: jsonResponse['user']['email'],
          role: jsonResponse['role'],
        );
        Employee employee = Employee(
          id: jsonResponse['employee']['id'],
          name: jsonResponse['employee']['name'],
          status: jsonResponse['employee']['status'],
          ordersDone: jsonResponse['employee']['ordersDone'],
          marketName: jsonResponse['employee']['marketName'],
        );
        currentUser!.employee = employee;
        setState(() {
          _loading = false;
        });
      } else {
        // If the request was not successful, handle the error
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? loadedWidget;
    switch (currentUser?.employee?.status) {
      case "Available":
        loadedWidget = EmployeePause();
        break;
      case "Break":
        loadedWidget = EmployeeResume();
        break;
      default:
        loadedWidget = EmployeeCart();
        break;
    }
    session_requests.setContext(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("Active Assignment"),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cloud-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : loadedWidget
      )
    );
  }
}