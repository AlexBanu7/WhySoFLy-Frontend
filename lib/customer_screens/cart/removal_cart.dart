import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

class RemovalCart extends StatefulWidget {
  const RemovalCart({super.key});

  @override
  State<RemovalCart> createState() => _RemovalCart();
}

class _RemovalCart extends State<RemovalCart>
    with SingleTickerProviderStateMixin{

  List<int> removedCartItemsIds = [];

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
          DataCell(
            Text(cartItem.quantity.toStringAsFixed(2)),
          ),
          DataCell(
            Text(cartItem.price.toStringAsFixed(2)),
          ),
          DataCell(
              Checkbox(
                value: removedCartItemsIds.contains(cartItem.id),
                onChanged: (bool? value) {
                  if (value!){
                    removedCartItemsIds.add(cartItem.id);
                  } else {
                    removedCartItemsIds.remove(cartItem.id);
                  }
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
    return Column(
        children: [
          const SizedBox(height: 20),
          const Text("You may remove items from the Cart before finalizing your order.",
            textAlign: TextAlign.center
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height - 300,
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
                  child:DataTable(
                      dataRowMaxHeight: 70,
                      dataRowMinHeight: 70,
                      columns: [
                        const DataColumn(label: Text('Name')),
                        const DataColumn(label: Text('Quantity')),
                        const DataColumn(label: Text('Price')),
                        DataColumn(label:
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            // You can use any delete icon you prefer
                            onPressed: () {},
                            iconSize: 25.0,
                            // Adjust the size as needed
                            color: Colors.red,
                          ),
                        ),
                      ],
                      rows: [
                        ..._generate_table_rows(),
                      ]
                  ),
                )
            ),
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top:20, bottom:30, left:20, right: 20),
            child: Center(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      cartService.removeBatchFromBackendCart(removedCartItemsIds)
                          .then((value) {
                            session_requests.sendMessage("Confirm Cart", context: context);
                            nav.refreshAndPushNamed(context, ['/cart']);
                          });
                    },
                    child: const Text('Complete Order'),
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }
}