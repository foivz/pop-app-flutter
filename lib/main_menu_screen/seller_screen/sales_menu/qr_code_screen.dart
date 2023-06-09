import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String invoiceId;
  const QRCodeScreen(this.invoiceId, {super.key});

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
            QrImageView(
              data: invoiceId,
              size: 200,
            ),
            Text("Invoice ID: $invoiceId"),
            const Text("Exit this screen once the buyer has scanned the code.")
          ]),
        ),
      ),
    );
  }
}
