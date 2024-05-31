import 'dart:core';
import 'dart:math';

import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

class LinearProgressBar extends StatefulWidget {
  const LinearProgressBar({super.key});

  @override
  State<LinearProgressBar> createState() => _LinearProgressBar();
}

class _LinearProgressBar extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation;

  Color backgroundColor = Colors.grey;
  Color valueColor = Colors.greenAccent;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Adjust the duration to control the speed
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.value = 0.0;
        Color temp = valueColor;
        setState(() {
          valueColor = backgroundColor;
          backgroundColor = temp;
        });
        _controller.forward();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          value: _animation.value,
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        );
      },
    );
  }
}