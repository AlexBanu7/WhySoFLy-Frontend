import 'package:flutter/material.dart';


class ConfirmationDialog extends StatefulWidget {

  final void Function() onConfirm;
  final String title;

  const ConfirmationDialog({super.key, required this.onConfirm, required this.title});

  @override
  _ConfirmationDialog createState() => _ConfirmationDialog();
}

class _ConfirmationDialog extends State<ConfirmationDialog>
    with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                widget.onConfirm();
                Navigator.pop(context);
              },
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

