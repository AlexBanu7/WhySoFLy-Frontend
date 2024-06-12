import 'package:flutter/material.dart';
import 'package:frontend/utils/utils.dart';


class OrderDetailsDialog extends StatefulWidget {

  final dynamic cart;

  const OrderDetailsDialog({super.key, required this.cart});

  @override
  _OrderDetailsDialog createState() => _OrderDetailsDialog();
}

class _OrderDetailsDialog extends State<OrderDetailsDialog>
    with SingleTickerProviderStateMixin{

  double _totalPrice = 0.0;
  double _totalVolume = 0.0;

  @override
  void initState() {
    super.initState();
    for (var item in widget.cart["cartItems"]) {
      _totalPrice += item["price"];
      _totalVolume += item["volume"];
    }
  }

  List<Widget> _populate_cart_items() {
    List<Widget> items = [];
    for (var item in widget.cart["cartItems"]) {
      items.add(
        Card(
          child: ListTile(
            title: Text(
              "${item["name"]}: ${item["quantity"]} units",
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            subtitle: Text(
              "Price: ${item["price"].toStringAsFixed(2)}\nVolume: ${item["volume"].toStringAsFixed(2)}",
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
          )
        )
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          "Order at ${widget.cart["marketName"]}",
          textAlign: TextAlign.center,
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Submission Date: ${ISOtoReadable(widget.cart["submissionDate"])}",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              Divider(),
              Text(
                "The Employee that took care of your order: ${widget.cart["employeeName"]}",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Total Price: ${_totalPrice.toStringAsFixed(2)}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Total Volume: ${_totalVolume.toStringAsFixed(2)}",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 200,
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                      stops: [0.0, 0.0, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: SingleChildScrollView(
                    child: Column(
                      children: _populate_cart_items(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ]
        )
    );
  }
}

