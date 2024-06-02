import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/widgets/login-dialog.dart';



class FilledCart extends StatefulWidget {
  const FilledCart({super.key, required this.onUpdate});

  final VoidCallback onUpdate;

  @override
  State<FilledCart> createState() => _FilledCart();
}

class _FilledCart extends State<FilledCart>
    with SingleTickerProviderStateMixin{

  @override
  void initState() {
    print("Inited filled cart");
    super.initState();
  }

  List<Widget> get_children() {
    List<Widget> cartItemsToChildren = [
      const Padding(
        padding: EdgeInsets.only(bottom: 10, top: 10, right: 25, left: 80),
        child: Row(
            children: [
              Expanded(
                child: Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Quantity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Replace YourFourthWidget with your actual widget
                ), // Replace YourThirdWidget with your actual widget
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Volume",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Replace YourFourthWidget with your actual widget
                ), // Replace YourThirdWidget with your actual widget
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Price",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // Replace YourFourthWidget with your actual widget
                ),
              ),
            ]
        ),
      )
    ];
    for (var cartitem in cartService.cartitems) {
      cartItemsToChildren.add(
          Padding(
              padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 10, right: 10, left: 10),
                    child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            // You can use any delete icon you prefer
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text(
                                        "Delete Item?",
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          ElevatedButton(
                                            onPressed: () {
                                              cartService.removeFromCart(cartitem);
                                              Navigator.pop(context);
                                              widget.onUpdate();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No'),
                                          )
                                        ],
                                      )
                                  );
                                },
                              );
                            },
                            iconSize: 25.0,
                            // Adjust the size as needed
                            color: Colors.red,
                          ),
                          Expanded(
                            child:Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(cartitem.name),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(cartitem.quantity.toStringAsFixed(2)),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(cartitem.volume.toStringAsFixed(2)),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(cartitem.price.toStringAsFixed(2)),
                            ),
                          ),
                        ]
                    ),
                  )
              )
          )
      );
    }
    return cartItemsToChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: ShaderMask(
            shaderCallback: (Rect rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
              ).createShader(rect);
            },
            blendMode: BlendMode.dstOut,
            child: ListView(
              children: get_children(),
            ),
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
                      Text(
                        'Volume Left: ${cartService.computeVolumeLeft().toStringAsFixed(2)} L',
                        style: const TextStyle(fontSize: 22.0),
                      ),
                    ],
                  ),
                ),
                const Spacer(), // Add space between the text and button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentUser != null){
                        nav.refreshAndPushNamed(context, ['/cart', '/checkout']);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const LoginDialog();
                          },
                        );
                      }
                    },
                    child: const Text('Checkout'),
                  ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}