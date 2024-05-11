import 'package:flutter/material.dart';
import 'package:frontend/screens/cart/cart.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/howto/howto.dart';
import 'package:frontend/screens/map/map.dart';
import 'package:frontend/screens/order/order.dart';
import 'package:frontend/utils/cart_service.dart';
import 'package:frontend/utils/session_requests.dart';
import 'package:frontend/utils/temp_inits.dart';

import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

User? currentUser;
TempInits tempInits = TempInits();
CartService cartService = CartService(tempInits.markets[0].id);
Session session_requests = Session();

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
        '/order': (context) => OrderPage(arguments: ModalRoute.of(context)?.settings.arguments)
      },
    );
  }
}