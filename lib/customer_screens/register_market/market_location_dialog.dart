import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MarketLocationDialog extends StatefulWidget {

  final void Function(LatLng?) onConfirm;

  const MarketLocationDialog({super.key, required this.onConfirm});

  @override
  _MarketLocationDialog createState() => _MarketLocationDialog();
}

class _MarketLocationDialog extends State<MarketLocationDialog>
    with SingleTickerProviderStateMixin{

  GoogleMapController? controller;

  LatLng? selectedLocation;

  Set<Marker> _markers = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(45.7489, 21.23),
    zoom: 13,
  );


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text(
          "Tap to pick your Market's Location",
          textAlign: TextAlign.center,
        ),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _onMapCreated(controller);
                  },
                  onTap: (LatLng location) {
                    _add_marker(location);
                    setState(() {
                      selectedLocation = location;
                    });
                  },
                  cloudMapId: 'bab3d6c7b6649b31',
                  markers: _markers, // Call _addMarker when user taps on the map
                ),
              ),

              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  widget.onConfirm(selectedLocation);
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ]
        )
    );
  }

  void _add_marker(LatLng location) {
    Set<Marker> newMarkers = {};
    newMarkers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          icon: BitmapDescriptor.defaultMarker,
        )
    );
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

