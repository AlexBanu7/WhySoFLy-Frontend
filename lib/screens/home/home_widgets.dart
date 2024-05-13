import 'package:flutter/material.dart';

class AnimatedSizeImage extends StatefulWidget {
  const AnimatedSizeImage({super.key});

  @override
  _AnimatedSizeImageState createState() => _AnimatedSizeImageState();
}

class _AnimatedSizeImageState extends State<AnimatedSizeImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSizeUp = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Adjust duration as needed
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double size = _isSizeUp
            ? 160.0 + (_controller.value * 50) // Adjust target size as needed
            : 150.0 + (_controller.value * 50); // Adjust target size as needed
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/map");
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cart.png', // Replace with your image path
                width: size,
                height: size,
                fit: BoxFit.cover, // Adjust fit as needed
              ),
              Transform.scale(
                scale: size/160,
                child: const Text(
                  'Start Shopping!', // Replace with your text
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ]
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}