import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import 'home_widgets.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin{
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Adjust duration as needed
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(""),
        drawer: CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/cloud-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Flying Plane
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      MediaQuery.of(context).size.width *
                          (_controller.value * 2 - 1), // Move horizontally
                      50, // Adjust vertical position as needed
                    ),
                    child: Transform.scale(
                      scale:0.4,
                      child:Image.asset(
                        'assets/images/airplane.png', // Path to your image
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              // Image at the bottom
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width, // full width
                  padding: EdgeInsets.zero,
                  child: Image.asset(
                    'assets/images/home-footer.png', // Path to your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Main content
              Center(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 200.0), // Adjust as needed
                    child: AnimatedSizeImage()
                ),
              ),
            ],
          ),
        )
    );
  }
}