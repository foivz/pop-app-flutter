import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SellerQRCodeScreen extends StatelessWidget {
  final String invoiceId;
  const SellerQRCodeScreen(this.invoiceId, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        if (context.mounted) {
          Navigator.popUntil(context, ModalRoute.withName("main_menu"));
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Finalize invoice")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Please, scan the code below."),
            const SizedBox(height: MyConstants.formInputSpacer),
            QrImageView(
              data: invoiceId,
              size: 200,
            ),
            Text("Invoice ID: $invoiceId"),
            const SizedBox(height: MyConstants.formInputSpacer),
            const SizedBox(
              width: 200,
              child: Text(
                "Exit this screen once the buyer has scanned the code.",
                textAlign: TextAlign.center,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
