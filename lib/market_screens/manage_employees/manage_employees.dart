import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/main.dart';
import 'package:frontend/market_screens/manage_employees/employee_card_dialog.dart';
import 'package:frontend/market_screens/manage_employees/invitation_dialog.dart';
import 'package:frontend/models/employee.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class ManageEmployeesPage extends StatefulWidget {
  const ManageEmployeesPage({super.key});

  @override
  State<ManageEmployeesPage> createState() => _ManageEmployeesPage();
}

class _ManageEmployeesPage extends State<ManageEmployeesPage>
    with SingleTickerProviderStateMixin{

  String? inviteKey;
  int? selectedEmployeeId;
  bool _loadingPendingInvites = true; // Track loading state
  bool _loadingActiveEmployees = true; // Track loading state
  List<dynamic> pendingInvites = [];
  List<dynamic> activeEmployees = [];

  @override
  void initState() {
    super.initState();
    getPendingInvites();
    getActiveEmployees();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getPendingInvites() async {
    setState(() {
      _loadingPendingInvites = true;
    });
    Map<String, dynamic> data = {
      'marketId': 12,
      'pending': true,
    };

    var response = await session_requests.post(
      '/api/Employee/GetEmployeesByMarket',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        pendingInvites = jsonResponse;
        _loadingPendingInvites = false;
      });
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> getActiveEmployees() async {
    setState(() {
      _loadingActiveEmployees = true;
    });
    Map<String, dynamic> data = {
      'marketId': 12,
      'pending': false,
    };

    var response = await session_requests.post(
      '/api/Employee/GetEmployeesByMarket',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        activeEmployees = jsonResponse;
        _loadingActiveEmployees = false;
      });
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> onApprove() async {
    Map<String, dynamic> data = {
      'employeeId': selectedEmployeeId,
    };

    var response = await session_requests.post(
      '/api/Market/approveRequest',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the request was successful, update the pending invites
      getPendingInvites();
      getActiveEmployees();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  Future<void> onReject() async {
    Map<String, dynamic> data = {
      'employeeId': selectedEmployeeId,
    };

    var response = await session_requests.post(
      '/api/Market/rejectRequest',
      json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // If the request was successful, update the pending invites
      getPendingInvites();
    } else {
      // If the request was not successful, handle the error
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  void onConfirmInvitationGenerate() {
    setState(() {
      inviteKey = currentUser?.market?.inviteKey;
    });
  }

  void _openInvitationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InvitationDialog(onConfirmInvitationGenerate: onConfirmInvitationGenerate);
      },
    );
  }

  List<Widget> _populate_pending_invites () {
    List<Widget> PendingInvites = [];
    for (var invite in pendingInvites) {
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
                  child: Text(invite["userAccount"]["email"]),
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
                          selectedEmployeeId = invite["id"];
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
                          selectedEmployeeId = invite["id"];
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
    return PendingInvites;
  }

  List<Widget> _populate_active_employees () {
    List<Widget> ActiveEmployees = [];
    for (var activeEmployee in activeEmployees) {
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
                    child: Text(activeEmployee["userAccount"]["email"]),
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
                            return EmployeeCardDialog(employee: Employee(
                              id: activeEmployee["id"],
                              name: activeEmployee["userAccount"]["email"],
                              status: activeEmployee["status"],
                              ordersDone: activeEmployee["ordersDone"],
                              marketName: activeEmployee["marketName"],
                            ));
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
                        if (inviteKey != null)
                          Container(
                            width: MediaQuery.of(context).size.width - 150,
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: inviteKey,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.content_copy),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: inviteKey??""));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Key copied to clipboard'),
                                        ),
                                      );
                                    },
                                  ) // Suffix Icon
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: _openInvitationDialog,
                          child: const Text('Get Invitation Key'),
                        ),
                        Container(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                  "Pending Invites",
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 20),
                              _loadingPendingInvites ? Center(child: CircularProgressIndicator())
                              : pendingInvites.length != 0 ?
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
                                  "Active Employees",
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 20),
                              _loadingActiveEmployees ? Center(child: CircularProgressIndicator())
                              : activeEmployees.length != 0 ?
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