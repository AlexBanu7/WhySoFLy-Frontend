import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/past_orders/order_details_dialog.dart';
import 'package:frontend/main.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class PastOrdersPage extends StatefulWidget {
  const PastOrdersPage({super.key});

  @override
  _PastOrdersPage createState() => _PastOrdersPage();
}

class _PastOrdersPage extends State<PastOrdersPage> {

  bool _loading = true;
  late List<dynamic> carts;

  @override
  void initState() {
    super.initState();
    getFinishedOrders();
  }

  Future<void> getFinishedOrders() async {

    setState(() {
      _loading = true;
    });

    var response  = await session_requests.post(
      '/api/Cart/Finished/ByCustomerEmail',
      json.encode(currentUser?.email),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      setState(() {
        _loading = false;
        carts = jsonResponse;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load carts');
    }
  }

  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar("Past Orders"),
        drawer: const CustomDrawer(),
        body: _loading ? Center(child: CircularProgressIndicator())
            : Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var cart in carts)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return OrderDetailsDialog(cart: cart);
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(cart['marketName']),
                        subtitle: Text(cart['submissionDate']),
                      ),
                    ),
                  )
              ],
            ),
          ),
        )
    );
  }
}