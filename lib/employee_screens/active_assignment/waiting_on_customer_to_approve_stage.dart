import 'dart:core';

import 'package:flutter/material.dart';

import '../../widgets/linear_progress_bar.dart';


class WaitingOnCustomerToApproveStage extends StatefulWidget {

  const WaitingOnCustomerToApproveStage({super.key});

  @override
  State<WaitingOnCustomerToApproveStage> createState() => _WaitingOnCustomerToApproveStage();
}

class _WaitingOnCustomerToApproveStage extends State<WaitingOnCustomerToApproveStage>
    with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            children: [
              const SizedBox(height:100),
              const Text("Waiting on customer to take action..."),
              const SizedBox(height:10),
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: LinearProgressBar()
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/awaiting-approval.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height:40)
            ]
        )
    );
  }
}