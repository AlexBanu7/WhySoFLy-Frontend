import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Navigation {

  refreshAndPushNamed(BuildContext context, List<String> routes) {
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    for (int i = 0; i < routes.length; i++) {
      Navigator.pushNamed(context, routes[i]);
    }
  }
}