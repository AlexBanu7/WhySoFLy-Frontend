import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/screens/cart/cart.dart';
import 'package:frontend/screens/checkout/checkout.dart';
import 'package:frontend/screens/home/home.dart';
import 'package:frontend/screens/howto/howto.dart';
import 'package:frontend/screens/map/map.dart';
import 'package:frontend/screens/order/order.dart';
import 'package:frontend/screens/register_employee/register_employee.dart';
import 'package:frontend/screens/register_market/register_market.dart';
import 'package:frontend/utils/cart_service.dart';
import 'package:frontend/utils/session_requests.dart';
import 'package:frontend/utils/temp_inits.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'package:frontend/models/user.dart';


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
        '/order': (context) => OrderPage(arguments: ModalRoute.of(context)?.settings.arguments),
        '/checkout': (context) => const CheckoutPage(),
        '/register_employee': (context) => const RegisterEmployeePage(),
        '/register_market': (context) => const RegisterMarketPage()
      },
    );
  }
}