import 'package:flutter/material.dart';
import 'package:frontend/screens/register_employee/employee_confirmation_dialog.dart';

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
  String _error = '';
  bool _loading = false; // Track loading state

  @override
  void dispose() {
    super.dispose();
  }

  void onConfirm() {
    setState(() {
      _loading = false; // Start loading
      _error = ''; // Clear previous error
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
        _error = ''; // Clear previous error
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
                              const SizedBox(height: 10),
                              Text(
                                _error,
                                style: const TextStyle(color: Colors.red),
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