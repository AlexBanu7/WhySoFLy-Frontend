import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';


class FetchProductStage extends StatefulWidget {

  const FetchProductStage({super.key});

  @override
  State<FetchProductStage> createState() => _FetchProductStage();
}

class _FetchProductStage extends State<FetchProductStage>
    with SingleTickerProviderStateMixin{

  // Create map that accounts for checked items
  Map<String, bool> checkedItems = {};

  @override
  void initState() {
    super.initState();
    setCheckedItems();
  }

  void setCheckedItems() {
    for (CartItem cartItem in cartService.cartitems) {
      checkedItems[cartItem.name] = false;
    }
  }

  List<DataRow> _generate_table_rows() {
    List<DataRow> tableRows = [];
    for (CartItem cartItem in cartService.cartitems){
      tableRows.add(
        DataRow(cells: [
          DataCell(Text(cartItem.name)),
          DataCell(Text(cartItem.quantity.toStringAsFixed(2))),
          DataCell(
              Checkbox(
                value: checkedItems[cartItem.name],
                onChanged: (bool? value) {
                  setState(() {
                    checkedItems[cartItem.name] = value!;
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
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 300,
              child: SingleChildScrollView(
                child:DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Gathered')),
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
                    const Spacer(), // Add space between the text and button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // check if all items have been gathered
                          bool allGathered = true;
                          for (bool gathered in checkedItems.values) {
                            if (!gathered) {
                              allGathered = false;
                              break;
                            }
                          }
                          if (!allGathered) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Please gather all items')));
                            return;
                          }
                          session_requests.sendMessage("Fetched Products", context: context);
                          nav.refreshAndPushNamed(context, ["/active_assignment"]);
                        },
                        child: const Text('Next Step'),
                      ),
                    ),
                  ],
                ),
              )
          )
        ]
    );
  }
}