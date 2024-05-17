import 'package:flutter/material.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

class EmployeeCardDialog extends StatefulWidget {

  final Employee employee;

  const EmployeeCardDialog({super.key, required this.employee});

  @override
  _EmployeeCardDialog createState() => _EmployeeCardDialog();
}

class _EmployeeCardDialog extends State<EmployeeCardDialog>
    with SingleTickerProviderStateMixin{

  void _onConfirmRemove() {

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

