import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

import '../main.dart';

class LogoutDialog extends StatefulWidget {

  final VoidCallback onUpdate;

  const LogoutDialog({super.key, required this.onUpdate});

  @override
  _LogoutDialog createState() => _LogoutDialog();
}

class _LogoutDialog extends State<LogoutDialog>
    with SingleTickerProviderStateMixin{

  int counter = 0;

  Future<void> _logout() async {

    var response = await session_requests.post(
      '/logout',
      json.encode(currentUser?.email),
    );

    if (response.statusCode == 200) {
      currentUser = null;
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
    return ConfirmationDialog(onConfirm: _logout, title: "Log out?");
  }
}

