import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/widgets/singup-dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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

  String error = '';
  bool _loading = false;
  bool _obscureText = true;

  Future<void> _login() async {
    setState(() {
      error = '';
      _loading = true;
    });
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var response = await session_requests.post(
        '/identity/userInfo',
        json.encode(email),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        // Create User from Request body
        currentUser = User(
          email: jsonResponse['user']['email'],
          role: jsonResponse['role'],
          userName: jsonResponse['user']['userName'],
        );
        if (jsonResponse["employee"] != null) {
          Employee employee = Employee(
            id: jsonResponse['employee']['id'],
            name: jsonResponse['employee']['name'],
            status: jsonResponse['employee']['status'],
            ordersDone: jsonResponse['employee']['ordersDone'],
            marketName: jsonResponse['employee']['marketName'],
          );
          currentUser!.employee = employee;
          final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
          themeProvider.setTheme(ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ));
        }
        if (jsonResponse["market"] != null) {
          Market market = Market(
            id: jsonResponse['market']['id'],
            name: jsonResponse['market']['name'],
            location: LatLng(
              double.tryParse(jsonResponse['market']['latitude'])??0.0,
              double.tryParse(jsonResponse['market']['longitude'])??0.0,
            ),
            inviteKey: jsonResponse['market']['invitationKey'],
            verified: jsonResponse['market']['verified'],
          );
          currentUser!.market = market;
          final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
          themeProvider.setTheme(ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
          ));
        }
        // Start WebSocket
        String redirectOnReceive;
        if (currentUser?.employee != null) {
          redirectOnReceive = "/active_assignment";
        } else if (currentUser?.market != null) {
          redirectOnReceive = "/home";
        } else {
          redirectOnReceive = "/cart";
        }
        session_requests.setUpChannel(redirectOnReceive);
        // Clear error message
        setState(() {
          error = '';
          _loading = false;
        });
        // Goto Dashboard
        Navigator.pushNamed(context, "/");
        const snackBar = SnackBar(
          content: Text('Welcome back!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // If the request was not successful, handle the error
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } else {
      setState(() {
        error = 'Invalid email or password. Please try again.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Wish to use our features?\n Log in to an account!",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
        child: Padding( // Add Padding widget
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust padding based on keyboard's visibility
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                error,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              if (_loading)
                const CircularProgressIndicator(),
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
          ),
        ),
      ),
    );
  }
}

