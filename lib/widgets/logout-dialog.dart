import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../utils/session_requests.dart';

class LogoutDialog extends StatefulWidget {

  final VoidCallback onUpdate;

  const LogoutDialog({required this.onUpdate});

  @override
  _LogoutDialog createState() => _LogoutDialog();
}

class _LogoutDialog extends State<LogoutDialog>
    with SingleTickerProviderStateMixin{

  int counter = 0;

  Future<void> _logout() async {

    var response = await session_requests.post(
      'http://192.168.1.103:5229/logout',
      json.encode(currentUser?.email),
    );

    if (response.statusCode == 200) {
      currentUser = null;
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('See you soon!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      widget.onUpdate();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Log out?",
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            )
          ],
        )
    );
  }
}

