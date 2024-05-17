
import 'package:flutter/material.dart';
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
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar("How To"),
      drawer: const CustomDrawer(),
      body: const Text("To be implemented!")
    );
  }
}