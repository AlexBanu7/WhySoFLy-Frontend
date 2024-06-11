import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/widgets/custom_appbar.dart';
import 'package:frontend/widgets/custom_drawer.dart';


class ReviewOrdersPage extends StatefulWidget {
  const ReviewOrdersPage({super.key});

  @override
  State<ReviewOrdersPage> createState() => _ReviewOrdersPage();
}

class _ReviewOrdersPage extends State<ReviewOrdersPage>
    with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    session_requests.setContext(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar("Review Orders"),
        drawer: const CustomDrawer(),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Review Orders',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        )
    );
  }
}