import 'dart:core';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeCart extends StatefulWidget {
  const QRCodeCart({super.key});

  @override
  State<QRCodeCart> createState() => _QRCodeCart();
}

class _QRCodeCart extends State<QRCodeCart>
    with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/cloud-bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Show this QR Code on premise to complete your order."),
              const SizedBox(height: 40),
              QrImageView(
                data: '/api/Cart/Finish/${cartService.backendId}',
                version: QrVersions.auto,
                size: 200.0,
              ),
              Spacer(),
              Image.asset("assets/images/scan.png"),
              const SizedBox(height: 40),
            ]
        )
      )
    );
  }
}