import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

class MarketCardDialog extends StatefulWidget {

  final Market market;
  final Function getMarkets;

  const MarketCardDialog({super.key, required this.market, required this.getMarkets});

  @override
  _MarketCardDialog createState() => _MarketCardDialog();
}

class _MarketCardDialog extends State<MarketCardDialog>
    with SingleTickerProviderStateMixin{

  Future<void> _onConfirmRemove() async {
    Map<String, dynamic> data = {
      'employeeId': widget.market.id,
    };

    var response = await session_requests.post(
      '/api/Market/rejectRequest',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the request was successful, update the pending invites
      Navigator.pop(context);
      widget.getMarkets();
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
                  widget.market.name,
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: IconButton(
                  icon: Icon(Icons.delete_forever),
                  color: Colors.red,
                  iconSize: 30,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                              onConfirm: _onConfirmRemove,
                              title: "Remove ${widget.market.name} from your Organization?"
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
                "Weekend Hours: ${widget.market.weekendHours}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Weekdays Hours: ${widget.market.weekdayHours}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Contact Email: ${widget.market.email}",
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

