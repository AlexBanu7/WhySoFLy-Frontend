import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/customer_screens/cart/cart.dart';
import 'package:frontend/customer_screens/checkout/checkout.dart';
import 'package:frontend/customer_screens/home/home.dart';
import 'package:frontend/customer_screens/howto/howto.dart';
import 'package:frontend/customer_screens/map/map.dart';
import 'package:frontend/customer_screens/order/order.dart';
import 'package:frontend/customer_screens/register_employee/register_employee.dart';
import 'package:frontend/customer_screens/register_market/register_market.dart';
import 'package:frontend/market_screens/manage_employees/manage_employees.dart';
import 'package:frontend/market_screens/manage_products/edit_product.dart';
import 'package:frontend/market_screens/manage_products/manage_products.dart';
import 'package:frontend/utils/cart_service.dart';
import 'package:frontend/utils/navigation.dart';
import 'package:frontend/utils/session_requests.dart';

import 'package:frontend/models/user.dart';
import 'package:uuid/uuid.dart';

import 'admin_screens/manage_markets/manage_markets.dart';
import 'employee_screens/active_assignment/active_assignment.dart';
import 'employee_screens/review_orders/review_orders.dart';


void main() {
  runApp(const MyApp());
}

User? currentUser;
CartService cartService = CartService();
Session session_requests = Session();
Navigation nav = Navigation();
Uuid uuid = Uuid();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MyHomePage(),
        '/map': (context) => const MapScreen(),
        '/howto': (context) => const HowToScreen(),
        '/cart': (context) => const CartPage(),
        '/order': (context) => OrderPage(arguments: ModalRoute.of(context)?.settings.arguments),
        '/checkout': (context) => const CheckoutPage(),
        '/register_employee': (context) => const RegisterEmployeePage(),
        '/register_market': (context) => const RegisterMarketPage(),
        '/manage_employees': (context) => const ManageEmployeesPage(),
        '/manage_products': (context) => const ManageProductsPage(),
        '/edit-product': (context) => EditProductPage(arguments: ModalRoute.of(context)?.settings.arguments),
        '/active_assignment': (context) => const ActiveAssignmentPage(),
        '/review_orders': (context) => const ReviewOrdersPage(),
        '/manage_markets': (context) => const ManageMarketsPage(),
      },
    );
  }
}