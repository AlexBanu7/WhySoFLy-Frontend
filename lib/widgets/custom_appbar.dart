import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/widgets/login-dialog.dart';

import '../main.dart';
import 'logout-dialog.dart';

class CustomAppBar extends AppBar {
  @override
  _CustomAppBar createState() => _CustomAppBar();
}

class _CustomAppBar extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {

  int _counter = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    IconButton profile_icon = currentUser != null ?
      IconButton(
        icon: SvgPicture.asset(
          'assets/icons/log-out.svg',
          semanticsLabel: 'Your SVG Icon',
          width: 40,
          // colorFilter: ,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return LogoutDialog(
                onUpdate: () {
                  setState(() {
                    _counter++;
                  });
                },
              );
            },
          );
        },
      )
        :
      IconButton(
        icon: SvgPicture.asset(
          'assets/icons/user-round.svg',
          semanticsLabel: 'Your SVG Icon',
          width: 40,
          // colorFilter: ,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return LoginDialog();
            },
          );
        },
      );
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(
        size: 40, // Adjust the size as per your requirement
      ),
      actions: [
        profile_icon
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}