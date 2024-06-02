import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/employee_screens/active_assignment/cart.dart';
import 'package:frontend/employee_screens/active_assignment/pause.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  bool _loading = true;
  int counter = 0;

  Future<void> updateWidget() async {
    print("Calling updateWidget");
    await updateInfo();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateInfo();
    }
  }

  Future<void> updateInfo () async {
    print("Loading...");
    setState(() {
      _loading = true;
    });
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
      print(employee);
      currentUser!.employee = employee;
      setState(() {
        _loading = false;
      });
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: StreamBuilder(
          stream: session_requests.channelBroadcastStream,
          builder: (context, snapshot) {
            print("heya, ich bin builder");
            print(currentUser?.employee?.status);
            if (snapshot.hasData) {
              return _loading ?
              const Center(child: CircularProgressIndicator()) : currentUser?.employee?.status == "Available" ?
              EmployeePause(updateWidget: updateWidget) : currentUser?.employee?.status == "Break" ?
              EmployeeResume(updateWidget: updateWidget) : EmployeeCart(updateWidget: updateWidget);
            } else {
              return _loading ?
              const Center(child: CircularProgressIndicator()) : currentUser?.employee?.status == "Available" ?
              EmployeePause(updateWidget: updateWidget) : currentUser?.employee?.status == "Break" ?
              EmployeeResume(updateWidget: updateWidget) : EmployeeCart(updateWidget: updateWidget);
            }
          },
        )
      )
    );
  }
}