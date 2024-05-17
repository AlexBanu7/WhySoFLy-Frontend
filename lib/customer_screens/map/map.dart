import 'dart:async';

import 'package:flutter/material.dart';
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

  void _populate_markers() {
    // TODO: Replace with api call
    Set<Marker> newMarkers = {};
    for (var market in tempInits.markets) {
      newMarkers.add(
          Marker(
            markerId: MarkerId(market.location.toString()),
            position: market.location,
            infoWindow: InfoWindow(
                title: 'Order at ${market.name}',
                onTap: () {
                  Navigator.pushNamed(context, '/order', arguments: market.name);
                }
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }
}