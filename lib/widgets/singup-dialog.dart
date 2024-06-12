import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';

import '../main.dart';

class SignupDialog extends StatefulWidget {
  const SignupDialog({super.key});

  @override
  _SignupDialog createState() => _SignupDialog();
}

class _SignupDialog extends State<SignupDialog>
    with SingleTickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _error = '';
  bool _loading = false; // Track loading state
  bool _obscureText = true;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
        _error = ''; // Clear previous error
      });

      Map<String, String> data = {
        'email': _email,
        'password': _password,
      };

      var response = await session_requests.post(
        '/register',
        json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // successfully registered, apply for Customer role
        var response = await session_requests.post(
          '/identity/assignRole',
          json.encode({
            'email': _email,
            'role': 'Customer'
          }),
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var response = await session_requests.patch(
            '/identity/userName',
            json.encode({
              'email': _email,
              'newUserName': _email.split('@')[0]
            }),
          );
          if (response.statusCode >= 200 && response.statusCode < 300) {
            Navigator.pushNamed(context, "/");
            var snackBar = SnackBar(
              content: Text('Account created! Your Username is "${_email.split('@')[0]}"'),
              duration: const Duration(days: 1), // Set a long duration
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            // If the request was not successful, handle the error
            throw Exception('Request failed with status: ${response.statusCode} and message ${response.body}');
          }
        } else {
          // If the request was not successful, handle the error
          throw Exception('Request failed with status: ${response.statusCode}');
        }
      } else {
        Map<String, dynamic> data = json.decode(response.body);
        Iterable<String> errorKeys = data["errors"].keys;
        String? firstErrorKey = errorKeys.isNotEmpty ? errorKeys.first : null;
        dynamic firstError = firstErrorKey != null ? data["errors"][firstErrorKey][0] : null;

        setState(() {
          _loading = false; // Stop loading
          _error = firstError as String;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Create an account",
        textAlign: TextAlign.center,
      ),
      content:Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              TextFormField(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your password.';
                  } else {
                    if (value != _password) {
                      return "Passwords do not match";
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _confirmPassword = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator() // Show circular progress indicator if loading
                  : ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
              const SizedBox(height: 20),
              Text(
                _error,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      );
  }
}

