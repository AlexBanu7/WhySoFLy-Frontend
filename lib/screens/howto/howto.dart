import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class HowToScreen extends StatefulWidget {
  const HowToScreen({super.key});

  @override
  _HowToScreen createState() => _HowToScreen();
}

class _HowToScreen extends State<HowToScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("How To"),
      drawer: CustomDrawer(),
      body: Text("To be implemented!")
    );
  }
}