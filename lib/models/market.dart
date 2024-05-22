import 'package:google_maps_flutter/google_maps_flutter.dart';

class Market {
  int id;
  String name;
  LatLng location;
  String? inviteKey;
  bool? verified;

  Market({required this.id, required this.name, required this.location, this.inviteKey, this.verified});
}