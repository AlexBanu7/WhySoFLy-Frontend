import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/register_employee/employee_confirmation_dialog.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/models/user.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({super.key});

  @override
  State<RegisterEmployeePage> createState() => _RegisterEmployeePage();
}

class _RegisterEmployeePage extends State<RegisterEmployeePage>
    with SingleTickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  String _key = '';
  bool _loading = false; // Track loading state

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onConfirm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
      });

      Map<String, String> data = {
        'email': currentUser?.email??"",
        'invitationKey': _key,
      };

      print(json.encode(data));

      var response = await session_requests.post(
        '/api/Market/claimInvite',
        json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // successfully registered, apply for Customer role
        var response = await session_requests.post(
          '/identity/assignRole',
          json.encode({
            'email': currentUser?.email??"",
            'role': 'Employee'
          }),
        );
        if (response.statusCode >= 200 && response.statusCode < 300) {
          var response = await session_requests.post(
            '/identity/userInfo',
            json.encode(currentUser?.email??""),
          );
          if (response.statusCode >= 200 && response.statusCode < 300) {
            // Parse the JSON response body into a Dart object
            final jsonResponse = json.decode(response.body);
            Employee employee = Employee(
              id: jsonResponse['employee']['id'],
              name: jsonResponse['employee']['name'],
              status: jsonResponse['employee']['status'],
              ordersDone: jsonResponse['employee']['ordersDone'],
              marketName: jsonResponse['employee']['marketName'],
            );
            currentUser = User(
                email: jsonResponse['user']['email'],
                role: jsonResponse['role'],
                employee: employee,
                market: jsonResponse['market']
            );
            Navigator.pop(context);
            const snackBar = SnackBar(
              content: Text('Your request has been sent! You will be notified when it is approved.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {
              _loading = false;
            });
          } else {
            // If the request was not successful, handle the error
            throw Exception('Request failed with status: ${response.statusCode}');
          }
        } else {
          // If the request was not successful, handle the error
          throw Exception('Request failed with status: ${response.statusCode}');
        }
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return EmployeeConfirmationDialog(onConfirm: onConfirm);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar("Join the team virtually!"),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cloud-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 400.0), // Adjust as needed
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Request your Employer for an invitation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Enter the given key',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your key.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _key = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              _loading
                                  ? const CircularProgressIndicator() // Show circular progress indicator if loading
                                  : ElevatedButton(
                                onPressed: _submitForm,
                                child: const Text('Send Request'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Image at the bottom
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width, // full width
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/images/employee.png', // Path to your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}