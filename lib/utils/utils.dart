import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color hexToColor(String hexString) {
  hexString = hexString.replaceAll('#', '');
  if (hexString.length == 6) {
    hexString = 'FF' + hexString; // add alpha value if missing
  }
  return Color(int.parse(hexString, radix: 16));
}

String ISOtoReadable(String isoString) {
  DateTime date = DateTime.parse(isoString);
  return DateFormat('dd/MM/yyyy H:mm').format(date);
}