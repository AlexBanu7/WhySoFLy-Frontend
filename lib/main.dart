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
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'package:frontend/models/user.dart';
import 'package:uuid/uuid.dart';

import 'employee_screens/active_assignment/active_assignment.dart';
import 'employee_screens/review_orders/review_orders.dart';


void main() {
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
    initializeMapRenderer();
  }
  runApp(const MyApp());
}

Completer<AndroidMapRenderer?>? _initializedRendererCompleter;

/// Initializes map renderer to the `latest` renderer type for Android platform.
///
/// The renderer must be requested before creating GoogleMap instances,
/// as the renderer can be initialized only once per application context.
Future<AndroidMapRenderer?> initializeMapRenderer() async {
  if (_initializedRendererCompleter != null) {
    return _initializedRendererCompleter!.future;
  }

  final Completer<AndroidMapRenderer?> completer =
  Completer<AndroidMapRenderer?>();
  _initializedRendererCompleter = completer;

  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    unawaited(mapsImplementation
        .initializeWithRenderer(AndroidMapRenderer.latest)
        .then((AndroidMapRenderer initializedRenderer) =>
        completer.complete(initializedRenderer)));
  } else {
    completer.complete(null);
  }

  return completer.future;
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
      },
    );
  }
}