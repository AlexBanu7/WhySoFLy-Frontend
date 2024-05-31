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
          color: Colors.white,
        ),
        Text(
          currentUser!.email,
          style: const TextStyle(
              fontSize: 20,
              color: Colors.white
          ),
        ),
        Text(
          currentUser!.role,
          style: const TextStyle(
              fontSize: 20,
              color: Colors.white
          ),
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
    List<Widget> customerSections = [
      ListTile(
        title: const Text('Home'),
        onTap: () {
          Navigator.pushNamed(context, "/");
        },
      ),
      ListTile(
        title: const Text('Map'),
        onTap: () {
          if (cartService.backendId != null) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Page locked while an order is in progress.'))
            );
          } else {
            Navigator.pushNamed(context, "/map");
          }
        },
      ),
      ListTile(
        title: const Text('Cart'),
        onTap: () {
          Navigator.pushNamed(context, "/cart");
        },
      ),
      ListTile(
        title: const Text('How to'),
        onTap: () {
          Navigator.pushNamed(context, "/howto");
        },
      ),
      ListTile(
        title: const Text('Become a Market Employee'),
        onTap: () {
          if (currentUser != null){
            if (cartService.backendId != null) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Page locked while an order is in progress.'))
              );
            } else {
              Navigator.pushNamed(context, "/register_employee");
            }
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
        title: const Text('Register your Market'),
        onTap: () {
          if (currentUser != null){
            if (cartService.backendId != null) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Page locked while an order is in progress.'))
              );
            } else {
              Navigator.pushNamed(context, "/register_market");
            }
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
    ];
    List<Widget> managerSections = [
      ListTile(
        title: const Text('Home'),
        onTap: () {
          Navigator.pushNamed(context, "/");
        },
      ),
      ListTile(
        title: const Text('Manage Employees'),
        onTap: () {
          Navigator.pushNamed(context, "/manage_employees");
        },
      ),
      ListTile(
        title: const Text('Manage Products'),
        onTap: () {
          Navigator.pushNamed(context, "/manage_products");
        },
      ),
      ListTile(
        title: const Text('How to'),
        onTap: () {
          Navigator.pushNamed(context, "/howto");
        },
      ),
    ];
    List<Widget> employeeSections = [
      ListTile(
        title: const Text('Home'),
        onTap: () {
          Navigator.pushNamed(context, "/");
        },
      ),
      ListTile(
        title: const Text('Review Orders'),
        onTap: () {
          if (currentUser?.employee?.status == "Pending Approval") {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Your employee status is still pending approval'))
            );
          } else {
            Navigator.pushNamed(context, "/review_orders");
          }
        },
      ),
      ListTile(
        title: const Text('Active Assignment'),
        onTap: () {
          if (currentUser?.employee?.status == "Pending Approval") {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Your employee status is still pending approval'))
            );
          } else {
            Navigator.pushNamed(context, "/active_assignment");
          }
        },
      ),
      ListTile(
        title: const Text('How to'),
        onTap: () {
          Navigator.pushNamed(context, "/howto");
        },
      ),
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 300,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: currentUser != null ?
                currentUser?.market != null ?
                Colors.orange :
                    currentUser?.employee != null ?
                        Colors.green
                    
                    : Colors.lightBlueAccent
                        : Colors.black12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: userOverview,
              ),
            ),
          ),
          if (currentUser == null || (currentUser?.market == null && currentUser?.employee == null))
            ...customerSections,
          if (currentUser?.market != null)
            ...managerSections,
          if (currentUser?.employee != null)
            ...employeeSections,
        ],
      ),
    );
  }

}