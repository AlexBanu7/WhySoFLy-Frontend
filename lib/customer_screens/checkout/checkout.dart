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

  @override
  void initState() {
    super.initState();
  }

  List<DataRow> _generate_table_rows() {
    List<DataRow> tableRows = [];
    for (CartItem cartItem in cartService.cartitems){
      tableRows.add(
        DataRow(cells: [
          DataCell(Text(cartItem.name)),
          DataCell(Text(cartItem.quantity.toStringAsFixed(2))),
          DataCell(Text(cartItem.price.toStringAsFixed(2))),
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
            child: SingleChildScrollView(
              child:DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                  ],
                  rows: [
                    ..._generate_table_rows(),
                  ]
              ),
            )
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
                  const Spacer(), // Add space between the text and button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Confirm order
                        cartService.confirmOrder().then(() {
                          // Navigator.pushNamed(context, '/order-confirmed');
                        } as FutureOr Function(void value));
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