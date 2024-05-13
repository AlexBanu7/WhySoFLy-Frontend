import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/widgets/singup-dialog.dart';

import '../main.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  _LoginDialog createState() => _LoginDialog();
}

class _LoginDialog extends State<LoginDialog>
    with SingleTickerProviderStateMixin{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    String email = emailController.text;
    String password = passwordController.text;

    Map<String, String> data = {
      'email': email,
      'password': password,
    };

    var response = await session_requests.post(
      '/login?useCookies=true&useSessionCookies=true',
      json.encode(data),
    );

    if (response.statusCode == 200) {
      var response = await session_requests.post(
        '/identity/userInfo',
        json.encode(email),
      );
      if (response.statusCode == 200) {
        // Parse the JSON response body into a Dart object
        final jsonResponse = json.decode(response.body);
        currentUser = User(email: jsonResponse['user']['email'],role: jsonResponse['role']);
        Navigator.pop(context);
        const snackBar = SnackBar(
          content: Text('Welcome back!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // If the request was not successful, handle the error
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } else {
      const snackBar = SnackBar(
        content: Text('Invalid Credentials'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Wish to use our features?\n Log in to an account!",
        textAlign: TextAlign.center,
      ),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Log in'),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Alternatively, register an account."
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SignupDialog();
                },
              );
            },
            child: const Text('Sign up'),
          )
        ],
      )
    );
  }
}

