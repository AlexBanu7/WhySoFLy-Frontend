import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/market_screens/manage_products/add_products.dart';
import 'package:frontend/market_screens/manage_products/products_in_sale.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';


class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPage();
}

class _ManageProductsPage extends State<ManageProductsPage>
    with SingleTickerProviderStateMixin{

  int _selectedTab = 0;

  // List of widgets to display in the body based on the selected index
  static const List<Widget> _tabOptions = <Widget>[
    ProductsInSaleTab(),
    AddProductsTab(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    return Scaffold(
      appBar: CustomAppBar("Products"),
      drawer: const CustomDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cloud-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            _tabOptions.elementAt(_selectedTab),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'In Sale',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
        ],
        currentIndex: _selectedTab,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}