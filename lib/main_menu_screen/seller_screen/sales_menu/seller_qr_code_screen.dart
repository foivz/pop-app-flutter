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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
              child: Text(
                "Or, if scanning fails, "
                "go back and recreate the invoice by pressing the button bellow.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            BackButton(onPressed: () => Navigator.pop(context))
          ]),
        ),
      ),
    );
  }
}
