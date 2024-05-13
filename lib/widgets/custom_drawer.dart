import 'package:flutter/material.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';
import 'package:frontend/widgets/login-dialog.dart';

import '../main.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

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
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          currentUser!.role,
          style: const TextStyle(fontSize: 20),
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
          SizedBox(
            height: 300,
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
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),
          ListTile(
            title: const Text('Map'),
            onTap: () {
              Navigator.pushNamed(context, "/map");
            },
          ),
          ListTile(
            title: const Text('Cart'),
            onTap: () {
              Navigator.pushNamed(context, "/cart");
            },
          ),
          ListTile(
            title: const Text('Become a Market Employee'),
            onTap: () {
              // TODO: Uncomment
              // if (currentUser != null){
                Navigator.pushNamed(context, "/register_employee");
              // } else {
              //   showDialog(
              //     context: context,
              //     builder: (BuildContext context) {
              //       return const LoginDialog();
              //     },
              //   );
              // }
            },
          ),
          ListTile(
            title: const Text('Register your Market'),
            onTap: () {
              if (currentUser != null){
                Navigator.pushNamed(context, "/register_employee");
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const LoginDialog();
                  },
                );
              }
            },
          ),
          ListTile(
            title: const Text('How to'),
            onTap: () {
              Navigator.pushNamed(context, "/howto");
            },
          ),
          // Add more ListTile widgets for additional menu items
        ],
      ),
    );
  }

}