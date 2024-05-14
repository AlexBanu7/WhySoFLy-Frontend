import 'package:flutter/material.dart';


class MarketConfirmationDialog extends StatefulWidget {

  final void Function() onConfirm;

  const MarketConfirmationDialog({super.key, required this.onConfirm});

  @override
  _MarketConfirmationDialog createState() => _MarketConfirmationDialog();
}

class _MarketConfirmationDialog extends State<MarketConfirmationDialog>
    with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Disclaimer",
          textAlign: TextAlign.center,
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Proceeding with this action will disable "
                    "Customer related features and clear out your Shopping Cart. "
                    "Upon receiving confirmation from the Management Team, you will "
                    "only have access to the Market side of our application.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Are you sure you want to continue?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
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
            ]
        )
    );
  }
}

