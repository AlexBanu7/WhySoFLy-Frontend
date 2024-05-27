import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/market.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

import 'package:frontend/main.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? controller;

  AndroidMapRenderer? _initializedRenderer;

  @override
  void initState() {
    initializeMapRenderer()
        .then<void>((AndroidMapRenderer? initializedRenderer) => setState(() {
      _initializedRenderer = initializedRenderer;
    }));
    super.initState();
  }

  Set<Marker> _markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.7489, 21.23),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("Map"),
      drawer: const CustomDrawer(),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _populate_markers();
          _onMapCreated(controller);
        },
        cloudMapId: 'bab3d6c7b6649b31',
        markers: _markers, // Call _addMarker when user taps on the map
      ),
    );
  }

  Future<void> _populate_markers() async {
    var response = await session_requests.get(
        '/api/Market'
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      var body = json.decode(response.body);
      print(body);
      Set<Marker> newMarkers = {};
      for (var market_in_body in body) {
        LatLng location = LatLng(double.tryParse(market_in_body['latitude'])??0, double.tryParse(market_in_body['longitude'])??0);
        Market market = Market(id: market_in_body['id'], name: market_in_body['name'], location: location);
        newMarkers.add(
            Marker(
              markerId: MarkerId(market.location.toString()),
              position: market.location,
              infoWindow: InfoWindow(
                  title: 'Order at ${market.name}',
                  onTap: () {
                    cartService.marketId = market.id;
                    Navigator.pushNamed(context, '/order', arguments: market);
                  }
              ),
              icon: BitmapDescriptor.defaultMarker,
            )
        );
      }
      setState(() {
        _markers = newMarkers;
      });
    } else {
      const snackBar = SnackBar(
        content: Text('Something went wrong! Please refresh the page'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }
}