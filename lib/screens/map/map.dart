import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  Set<Marker> _markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.7489, 21.23),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Map"),
      drawer: CustomDrawer(),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _populate_markers();
          _controller.complete(controller);
        },
        cloudMapId: 'bab3d6c7b6649b31',
        markers: _markers, // Call _addMarker when user taps on the map
      ),
    );
  }

  void _populate_markers() {
    // TODO: Replace with api call
    Set<Marker> _new_markers = {};
    for (var market in tempInits.markets) {
      _new_markers.add(
          Marker(
            markerId: MarkerId(market.location.toString()),
            position: market.location,
            infoWindow: InfoWindow(
                title: 'Order at ${market.name}',
                onTap: () {
                  print("Trapped!");
                }
            ),
            icon: BitmapDescriptor.defaultMarker,
          )
      );
    }
    setState(() {
      _markers = _new_markers;
    });
  }
}