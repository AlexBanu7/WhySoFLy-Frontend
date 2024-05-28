import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/widgets/linear_progress_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InProgressCart extends StatefulWidget {
  const InProgressCart({super.key});

  @override
  State<InProgressCart> createState() => _InProgressCart();
}

class _InProgressCart extends State<InProgressCart>
    with SingleTickerProviderStateMixin{

  Future<void> _navigate_to_order_page() async {
    var response = await session_requests.get(
        '/api/Market/${cartService.marketId}'
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = json.decode(response.body);
      Market market = Market(
          id: body['id'],
          name: body['name'],
          location: LatLng(
              double.tryParse(body['latitude'])??0.0,
              double.tryParse(body['longitude'])??0.0
          )
      );
      Navigator.pushNamed(context, '/order', arguments: market);
    }
    else {
      throw Exception("Failed to get market");
    }
  }

  List<Card> _populate_cart_items_accordion() {
    List<Card> cart_items_to_sections = [];
    for (var cartItem in cartService.cartitems) {
      cart_items_to_sections.add(
         Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(cartItem.name),
                    const Spacer(),
                    Text(cartItem.quantity.toStringAsFixed(2) + " Units"),
                    const Spacer(),
                    Text(cartItem.price.toStringAsFixed(2) + " RON"),
                  ],
                ),
              )
          )
      );
    }
    return cart_items_to_sections;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            children: [
              SizedBox(height:40),
              const Text("Your Cart Items are being gathered. Please wait."),
              SizedBox(height:10),
              Padding(
                padding: EdgeInsets.all(10),
                child: LinearProgressBar()
              ),
              SizedBox(height:10),
              Container(
                height: 400,
                child: Accordion(
                    headerBackgroundColorOpened: Colors.transparent,
                    headerBorderWidth: 3,
                    headerBackgroundColor: Colors.transparent,
                    contentBackgroundColor: Colors.transparent,
                    contentBorderWidth: 0,
                    contentHorizontalPadding: 0,
                    scaleWhenAnimating: false,
                    openAndCloseAnimation: true,
                    paddingBetweenClosedSections: 30,
                    paddingBetweenOpenSections: 30,
                    headerPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    rightIcon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
                    children: [AccordionSection(
                        headerBorderColor: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                        headerBorderColorOpened: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                        header: const Text("Items in Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        content: Column(
                          children: _populate_cart_items_accordion()
                        )
                      )
                  ]
                )
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'At this stage, more products can be added. Order Time will increase. They cannot be verified by photography.',
                  style: const TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: _navigate_to_order_page,
                child: const Text('Add more Items'),
              ),
              SizedBox(height:40)
            ]
        )
    );
  }
}