import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/employee_screens/active_assignment/qr_scan.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';

class AcknowledgeRemovalAndScan extends StatefulWidget {

  const AcknowledgeRemovalAndScan({super.key});

  @override
  State<AcknowledgeRemovalAndScan> createState() => _AcknowledgeRemovalAndScan();
}

class _AcknowledgeRemovalAndScan extends State<AcknowledgeRemovalAndScan>
    with SingleTickerProviderStateMixin{

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = true;
    });
    cartService.getCart(false, removedOnly: true).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  bool acknowledged = false;

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
                style: const TextStyle(
                  color: Colors.redAccent
                ),
              ),
            ),
          ),
          DataCell(
            Text(cartItem.quantity.toStringAsFixed(2),
              style: const TextStyle(
                  color: Colors.redAccent
              ),
            ),
          ),
        ]),
      );
    }
    return tableRows;
  }

  @override
  Widget build(BuildContext context) {
    return _loading
    ? const Center(child: CircularProgressIndicator())
    : !acknowledged
        ? Column(
            children: [
              const SizedBox(height: 20),
              if (cartService.cartitems.length == 0)
                Column(
                  children: [
                    const Text("No items removed by the customer",
                      textAlign: TextAlign.center
                    ),
                    SizedBox(height: 40),
                    Padding(
                        padding: EdgeInsets.all(30),
                        child: Image.asset('assets/images/ok.png')
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    const Text("Items removed by the customer",
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
                                columns: const [
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Quantity')),
                                ],
                                rows: [
                                  ..._generate_table_rows(),
                                ]
                            ),
                          )
                      ),
                    ),
                  ],
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
                          setState(() {
                            acknowledged = true;
                          });
                        },
                        child: const Text('Acknowledge'),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          )
        : QRScan();
  }
}