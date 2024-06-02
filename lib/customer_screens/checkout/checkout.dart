import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';
import 'package:frontend/customer_screens/cart/empty_cart.dart';
import 'package:frontend/customer_screens/cart/filled_cart.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPage();
}

class _CheckoutPage extends State<CheckoutPage>
    with SingleTickerProviderStateMixin{

  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  List<DataRow> _generate_table_rows() {
    List<DataRow> tableRows = [];
    for (CartItem cartItem in cartService.cartitems){
      tableRows.add(
        DataRow(cells: [
          DataCell(
            Container(
              width: 70,
                child: Text(
                  cartItem.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
            ),
          ),
          DataCell(Text(cartItem.quantity.toStringAsFixed(2))),
          DataCell(Text(cartItem.price.toStringAsFixed(2))),
          DataCell(
            Checkbox(
              value: cartItem.accepted,
              onChanged: (bool? value) {
                cartService.setAccepted(cartItem, value!);
                setState(() {

                });
              },
            )
          ),
        ]),
      );
    }
    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Order Overview"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 300,
            child: DataTable(
                  dataRowMaxHeight: 70,
                  dataRowMinHeight: 70,
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Photo')),
                  ],
                  rows: [
                    ..._generate_table_rows(),
                  ]
              ),
          ),
          Expanded(
            child:Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top:20, bottom:30, left:20, right: 20),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center, // Center the children horizontally
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Total Price: ${cartService.calculateTotalPrice().toStringAsFixed(2)} RON',
                          style: const TextStyle(fontSize: 22.0),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.center, // Center the children horizontally
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Photo requests may increase order time',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(), // Add space between the text and button
                  if (_loading)
                    const CircularProgressIndicator(),
                  if (_loading)
                    const Text(
                      "Your order will be picked up soon!",
                      style: TextStyle(
                          fontSize: 16.0,
                        fontStyle: FontStyle.italic
                      )
                    ),
                  if (!_loading)
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Confirm order
                          cartService.confirmOrder().then((void value) {
                            session_requests.sendMessage("Checkout Customer");
                          });
                          setState(() {
                            _loading = true;
                          });
                        },
                        child: const Text('Confirm Order'),
                      ),
                    ),
                ],
              ),
            )
          )
        ],
      )
    );
  }
}