import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends AppBar {
  @override
  _CustomAppBar createState() => _CustomAppBar();
}

class _CustomAppBar extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(
        size: 40, // Adjust the size as per your requirement
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/user-round.svg',
            semanticsLabel: 'Your SVG Icon',
            width: 40,
            // colorFilter: ,
          ),
          onPressed: () {
            // Add your onPressed logic here
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}