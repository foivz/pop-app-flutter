import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/main_menu_screen/buyer_screen/buying_screen/qr_scanner_screen.dart';
import 'package:pop_app/myconstants.dart';

class BuyingScreen extends StatelessWidget {
  const BuyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Commit purchase")),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      "Make sure the seller is ready to sell the product!",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: MyConstants.formInputSpacer * 4),
                  FormSubmitButton(
                    buttonText: 'Scan the QR Code',
                    color: MyConstants.accentColor2,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRScannerScreen(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
