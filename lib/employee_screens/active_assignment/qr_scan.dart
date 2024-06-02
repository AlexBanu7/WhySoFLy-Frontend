import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/main.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScan();
}

class _QRScan extends State<QRScan>
    with SingleTickerProviderStateMixin{

  String? scannedData;

  Future<void> scanQR () async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.QR,
      );
      if(!mounted) return;
      setState(() {
        scannedData = qrCode.toString();
      });
    } on PlatformException {
      scannedData = "Failed to get data";
    }
  }


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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        "Scan the QR Code provided by the customer to complete the order.",
                        textAlign: TextAlign.center,
                    ),
                  ),
                  ElevatedButton(
                   onPressed: scanQR,
                   child: Text("Scan QR Code")),
                  if (scannedData != null)
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text("Succesfully Scanned Data"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmationDialog(
                                        onConfirm: () {
                                          cartService.finishOrder(scannedData!);
                                          session_requests.sendMessage("Finish Order");
                                        },
                                        title: "Confirm order completion?"
                                    );
                                  }
                              );
                            },
                            child: Text("Complete Order"))
                      ],
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