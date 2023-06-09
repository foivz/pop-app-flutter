import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/buyer_screen/buying_screen/qr_scanner_screen.dart';
import 'package:pop_app/myconstants.dart';

class BuyingScreen extends StatelessWidget {
  const BuyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Commit purchase")),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Make sure the seller is ready to sell the product!",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 25,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) => MyConstants.red)),
                child: const Text(
                  'Scan the QR Code',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRScannerScreen(),
                  ));
                },
              ),
            ],
          ),
        ));
  }
}
