import 'package:flutter/material.dart';

class BuyerDialog extends StatelessWidget {
  const BuyerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Payment method'),
      content: const Text('Choose payment method:'),
      actions: <Widget>[
        TextButton(
          child: const Text('QR Code'),
          onPressed: () {
            // TODO: Handle QR Code option
          },
        ),
        TextButton(
          child: const Text('NFC'),
          onPressed: () {
            // TODO: Handle NFC option
          },
        ),
      ],
    );
  }
}
