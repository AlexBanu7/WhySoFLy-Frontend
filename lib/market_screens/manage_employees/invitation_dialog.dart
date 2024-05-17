import 'package:flutter/material.dart';


class InvitationDialog extends StatefulWidget {

  final void Function() onConfirmInvitationGenerate;

  const InvitationDialog({super.key, required this.onConfirmInvitationGenerate});

  @override
  _InvitationDialog createState() => _InvitationDialog();
}

class _InvitationDialog extends State<InvitationDialog>
    with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Invite an Employee to your Organization",
          textAlign: TextAlign.center,
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "You will be provided with an Invitation Key "
                    "that must be forwarded to an Employee. "
                    "Once they use it, a new Join Request will appear "
                    "on this page, which can be Accepted or Rejected.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  widget.onConfirmInvitationGenerate();
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ]
        )
    );
  }
}

