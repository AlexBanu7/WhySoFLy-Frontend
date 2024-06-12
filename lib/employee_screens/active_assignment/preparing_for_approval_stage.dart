import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/cartitem.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';
import 'package:frontend/widgets/image_input.dart';


class PreparingForApprovalStage extends StatefulWidget {

  const PreparingForApprovalStage({super.key});

  @override
  State<PreparingForApprovalStage> createState() => _PreparingForApprovalStage();
}

class _PreparingForApprovalStage extends State<PreparingForApprovalStage>
    with SingleTickerProviderStateMixin{

  // Create map that accounts for checked items
  Map<int, File?> photos = {};
  int? currentItemId;

  @override
  void initState() {
    super.initState();
    setEmptyImages();
  }

  void setEmptyImages() {
    for (CartItem cartItem in cartService.cartitems) {
      if (!cartItem.accepted) {
        photos[cartItem.id] = null;
      }
    }
  }

  void passImage(File passedImage) {
    setState(() {
      photos[currentItemId!] = passedImage;
    });
  }

  List<DataRow> _generate_table_rows() {
    List<DataRow> tableRows = [];
    for (CartItem cartItem in cartService.cartitems){
      if (!cartItem.accepted) {
        tableRows.add(
          DataRow(cells: [
            DataCell(Text(cartItem.name)),
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
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            child: ImageInput(
                                passImage: passImage,
                                initialImageFile: photos[cartItem.id]
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
                  value: photos[cartItem.id] != null,
                  onChanged: (bool? value) {},
                )
            ),
          ]),
        );
      }
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
                      DataColumn(label: Text('Photo')),
                      DataColumn(label: Text('Ready')),
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
                          // check if all photos have been taken
                          bool allPhotographed = true;
                          for (File? photo in photos.values) {
                            if (photo == null) {
                              allPhotographed = false;
                              break;
                            }
                          }
                          if (!allPhotographed) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Please photograph all items')));
                            return;
                          }
                          cartService.patchCartItemsPhotos(photos).then((value) {
                            session_requests.sendMessage("Attached Photos", context: context);
                          });
                          nav.refreshAndPushNamed(context, ['/active_assignment']);
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