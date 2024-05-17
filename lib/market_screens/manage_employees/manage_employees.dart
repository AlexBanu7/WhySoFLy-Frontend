import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/customer_screens/register_market/market_confirmation_dialog.dart';
import 'package:frontend/customer_screens/register_market/market_location_dialog.dart';
import 'package:frontend/main.dart';
import 'package:frontend/market_screens/manage_employees/employee_card_dialog.dart';
import 'package:frontend/market_screens/manage_employees/invitation_dialog.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
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
  bool _loading = false; // Track loading state

  @override
  void dispose() {
    super.dispose();
  }

  void onConfirm() {
    setState(() {
      _loading = false; // Start loading
    });
  }

  void onConfirmInvitationGenerate() {
    setState(() {
      inviteKey = uuid.v4();
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
    return [
      Card(
        shadowColor: Colors.black26,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 20),
          child:Row(
            children: [
              Expanded(
                flex:5,
                child: Text("alexbanu2001@gmail.com"),
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
                        return ConfirmationDialog(onConfirm: onConfirm, title: "Accept Request?");
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
                        return ConfirmationDialog(onConfirm: onConfirm, title: "Reject Request?");
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
    ];
  }

  List<Widget> _populate_active_employees () {
    return [
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
              const Expanded(
                flex:2,
                child: Text("alexbanu2001@gmail.com"),
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
                        return EmployeeCardDialog(employee: tempInits.employees[0]);
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
    ];
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
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                  "Active Employees",
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                              const SizedBox(height: 20),
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