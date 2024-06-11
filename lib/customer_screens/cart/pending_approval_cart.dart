import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

class PendingApprovalCart extends StatefulWidget {
  const PendingApprovalCart({super.key});

  @override
  State<PendingApprovalCart> createState() => _PendingApprovalCart();
}

class _PendingApprovalCart extends State<PendingApprovalCart>
    with SingleTickerProviderStateMixin{

  int? currentItemId;
  List<CartItem> initialUnacceptedList = [];

  @override
  void initState() {
    super.initState();
    initialUnacceptedList = cartService.cartitems.where((element) => !element.accepted).toList();
  }

  List<DataRow> _generate_pending_approval_table_rows() {
    List<DataRow> tableRows = [];
    for (CartItem cartItem in initialUnacceptedList){
      tableRows.add(
        DataRow(cells: [
          DataCell(
            Container(
              width: 150,
              child: Text(
                cartItem.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () {
                currentItemId = cartItem.id;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Text(
                          cartItem.name,
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          child: Image.memory(
                            base64Decode(cartItem.image!.split(',').last),
                          ),
                        )
                    );
                  },
                );
              },
              iconSize: 25.0,
              // Adjust the size as needed
              color: Colors.green,
            ),
          ),
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
    return Column(
        children: [
          SizedBox(height: 20),
          Text("Items pending Approval"),
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
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Photo')),
                      DataColumn(label: Text('Accept')),
                    ],
                    rows: [
                      ..._generate_pending_approval_table_rows(),
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
                  const Text(
                      "Leave a product unchecked if you wish for a new photo",
                    textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      List<CartItem> approvedItems = [];
                      for (CartItem cartItem in initialUnacceptedList){
                        if (cartItem.accepted){
                          approvedItems.add(cartItem);
                        }
                      }
                      cartService.approveBatchFromBackendCart(approvedItems)
                        .then((value) {
                          session_requests.sendMessage("Submitted Review", context: context);
                          nav.refreshAndPushNamed(context, ['/cart']);
                        });
                    },
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }
}