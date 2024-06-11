import 'package:flutter/material.dart';

Color hexToColor(String hexString) {
  hexString = hexString.replaceAll('#', '');
  if (hexString.length == 6) {
    hexString = 'FF' + hexString; // add alpha value if missing
  }
  return Color(int.parse(hexString, radix: 16));
}