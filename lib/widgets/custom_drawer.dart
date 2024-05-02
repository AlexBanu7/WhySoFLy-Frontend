import 'package:flutter/material.dart';

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
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