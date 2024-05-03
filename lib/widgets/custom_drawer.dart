import 'package:flutter/material.dart';

import '../main.dart';
import '../models/user.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawer createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> userOverview = [];
    if (currentUser != null) {
      userOverview.addAll([
        Image.asset(
          'assets/images/user.png',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
        Text(
          currentUser!.email,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          currentUser!.role,
          style: TextStyle(fontSize: 20),
        ),
      ]);
    } else {
      userOverview.addAll([
        Image.asset(
          'assets/images/guest.png', // Replace with your image path
          width: 150,
          height: 150,
          fit: BoxFit.cover, // Adjust fit as needed
        ),
        const Text(
          'Guest', // Replace with your text
          style: TextStyle(fontSize: 20),
        ),
      ]);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: currentUser != null ? Colors.lightBlueAccent : Colors.black12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: userOverview,
              ),
            ),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Implement item 1 functionality here
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Implement item 2 functionality here
            },
          ),
          // Add more ListTile widgets for additional menu items
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}