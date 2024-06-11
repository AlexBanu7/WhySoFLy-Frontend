import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

class EmployeeCardDialog extends StatefulWidget {

  final Employee employee;
  final Function getActiveEmployees;

  const EmployeeCardDialog({super.key, required this.employee, required this.getActiveEmployees});

  @override
  _EmployeeCardDialog createState() => _EmployeeCardDialog();
}

class _EmployeeCardDialog extends State<EmployeeCardDialog>
    with SingleTickerProviderStateMixin{

  Future<void> _onConfirmRemove() async {
    Map<String, dynamic> data = {
      'employeeId': widget.employee.id,
    };

    var response = await session_requests.post(
      '/api/Employee/rejectRequest',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the request was successful, update the pending invites
      Navigator.pop(context);
      widget.getActiveEmployees();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.employee.name,
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            right: 0.0,
            top: 0.0,
            child: IconButton(
              icon: Icon(Icons.person_off),
              color: Colors.red,
              iconSize: 30,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                        onConfirm: _onConfirmRemove,
                        title: "Remove ${widget.employee.name} from your Organization?"
                    );
                  }
                );
              },
            ),
          ),
        ]
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Status: ${widget.employee.status}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            "Orders Finished: ${widget.employee.ordersDone}",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ]
      )
    );
  }
}

