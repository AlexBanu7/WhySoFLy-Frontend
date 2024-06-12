import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/admin_screens/manage_markets/market_card_dialog.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/market.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class ManageMarketsPage extends StatefulWidget {
  const ManageMarketsPage({super.key});

  @override
  State<ManageMarketsPage> createState() => _ManageMarketsPage();
}

class _ManageMarketsPage extends State<ManageMarketsPage>
    with SingleTickerProviderStateMixin{

  int? selectedMarketId;
  bool _loadingPendingMarkets = true; // Track loading state
  bool _loadingActiveMarkets = true; // Track loading state
  List<dynamic> markets = [];

  @override
  void initState() {
    super.initState();
    getMarkets();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getMarkets() async {
    setState(() {
      _loadingPendingMarkets = true;
      _loadingActiveMarkets = true;
    });

    var response = await session_requests.get(
      '/api/Market/Untempered',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        markets = jsonResponse;
        _loadingPendingMarkets = false;
        _loadingActiveMarkets = false;
      });
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> onApprove() async {
    Map<String, dynamic> data = {
      'employeeId': selectedMarketId,
    };

    var response = await session_requests.post(
      '/api/Market/approveRequest',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      getMarkets();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> onReject() async {
    Map<String, dynamic> data = {
      'employeeId': selectedMarketId,
    };

    var response = await session_requests.post(
      '/api/Market/rejectRequest',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      getMarkets();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  List<Widget> _populate_pending_invites () {
    List<Widget> PendingInvites = [];
    for (var market in markets) {
      if (market["verified"] == false) {
        PendingInvites.add(
          Card(
            shadowColor: Colors.black26,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 20),
              child:Row(
                children: [
                  Expanded(
                    flex:5,
                    child: Text(market["userAccount"]["email"]),
                  ),
                  Expanded(
                    flex:1,
                    child: IconButton(
                      icon: const Icon(Icons.check_circle),
                      // You can use any delete icon you prefer
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            selectedMarketId = market["id"];
                            return ConfirmationDialog(onConfirm: onApprove, title: "Accept Request?");
                          },
                        );
                      },
                      iconSize: 25.0,
                      // Adjust the size as needed
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      // You can use any delete icon you prefer
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            selectedMarketId = market["id"];
                            return ConfirmationDialog(onConfirm: onReject, title: "Reject Request?");
                          },
                        );
                      },
                      iconSize: 25.0,
                      // Adjust the size as needed
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
    return PendingInvites;
  }

  List<Widget> _populate_active_employees () {
    List<Widget> ActiveEmployees = [];
    for (var market in markets) {
      if(market["verified"] == false) {
        continue;
      }
      ActiveEmployees.add(
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12, // Set the color of the border
                  width: 1.0, // Set the width of the border
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 20),
              child:Row(
                children: [
                  Expanded(
                    flex:2,
                    child: Text(market["userAccount"]["email"]),
                  ),
                  Expanded(
                    flex:1,
                    child: IconButton(
                      icon: const Icon(Icons.person_pin_sharp),
                      // You can use any delete icon you prefer
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MarketCardDialog(market: Market(
                              id: market["id"],
                              name: market["name"],
                              email: market["userAccount"]["email"],
                              weekdayHours: market["storeHours"]["workDay"],
                              weekendHours: market["storeHours"]["weekend"],
                              verified: market["verified"],
                              location: LatLng(
                                double.tryParse(market["latitude"])??0.0,
                                double.tryParse(market["longitude"])??0.0,
                              ),
                            ),
                              getMarkets: getMarkets,
                            );
                          },
                        );
                      },
                      iconSize: 25.0,
                      // Adjust the size as needed
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          )
      );
    }
    return ActiveEmployees;
  }

  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar("Management"),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cloud-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0), // Adjust as needed
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Pending Approvals",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 20),
                              _loadingPendingMarkets ? Center(child: CircularProgressIndicator())
                                  : markets.where((m) => m["verified"] == false).toList().length != 0 ?
                              Container(
                                height: 200,
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
                                  child: ListView(
                                    children: _populate_pending_invites(),
                                  ),
                                ),
                              )
                                  : const Text(
                                "It does get pretty lonely around here...",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "Active Markets",
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 20),
                              _loadingActiveMarkets ? Center(child: CircularProgressIndicator())
                                  : markets.where((m) => m["verified"] == true).toList().length != 0 ?
                              Container(
                                height: 200,
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
                                  child: ListView(
                                    children: _populate_active_employees(),
                                  ),
                                ),
                              )
                                  :
                              const Text(
                                "I'm sure they'll come...",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}