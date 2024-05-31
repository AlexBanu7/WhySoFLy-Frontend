import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_drawer.dart';


class EmployeeResume extends StatefulWidget {

  final VoidCallback updateWidget;

  const EmployeeResume({super.key, required this.updateWidget});

  @override
  State<EmployeeResume> createState() => _EmployeeResume();
}

class _EmployeeResume extends State<EmployeeResume>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  Future<void> resume() async {
    var response = await session_requests.post(
      '/api/Employee/GoAvailable',
      json.encode(currentUser?.email),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      widget.updateWidget();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(
              'ON BREAK',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Text(
              'Catching a breath...',
              style: TextStyle(
                  fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Spacer(),
          Image.asset("assets/images/chilling.png"),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: resume,
              child: const Text(
                'Resume Work',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}