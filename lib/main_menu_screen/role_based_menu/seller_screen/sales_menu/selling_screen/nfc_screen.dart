import 'dart:convert';

import 'package:pop_app/main_menu_screen/invoices_screen/invoice_details_screen/invoice_details_screen.dart';
import 'package:pop_app/models/initial_invoice.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:pop_app/models/invoice.dart';
import 'package:pop_app/utils/api_requests.dart';
import 'package:pop_app/utils/myconstants.dart';
// import 'package:ndef/ndef.dart' as ndef; // TODO: uncomment this when implementing NFC

import 'package:flutter/material.dart';

class SellerNFCScreen extends StatefulWidget {
  final InitialInvoice invoice;
  const SellerNFCScreen({super.key, required this.invoice});
  @override
  State<StatefulWidget> createState() => _SellerNFCScreenState();
}

class _SellerNFCScreenState extends State<SellerNFCScreen> {
  bool nfcRead = false;

  @override
  void initState() {
    super.initState();
    _initNFC();
  }

  void _initNFC() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      if (context.mounted) {
        Message.error(context).show("NFC is not available on this device.");
        Navigator.pop(context, false);
      }
    } else {
      // optional "timeout" attribute is android-exclusive
      var tag = await FlutterNfcKit.transceive(
          widget.invoice.code); // TODO: test :: probably sends code. right?
      if (tag.toString() == widget.invoice.code) {
        nfcRead = true;
        print(jsonEncode(tag));
      }
      print("not succesfully read yet but here we go");
      print(jsonEncode(tag));
    }
  }

  void attemptToFinalizeInvoice(String readCode) async {
    Invoice? invoice;
    try {
      invoice = await ApiRequestManager.finalizeInvoiceViaQR(readCode);
      if (context.mounted) {
        if (invoice != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return InvoiceDetailsScreen(invoice!);
          }), result: true);
        } else {
          Message.error(context).show("Something went wrong, try again.");
        }
      }
    } on FormatException {
      Message.error(context).show("You cannot proceed with this invoice.");
      Navigator.pop(context, false);
    } catch (e) {
      Message.error(context).show(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment via NFC")),
      body: _buildNFCView(context),
      bottomSheet: Container(
        width: double.infinity,
        decoration: _roundBorder,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          !nfcRead ? "Touch your device to the seller's device." : "Processing...",
          style: TextStyle(color: !nfcRead ? Colors.white : MyConstants.accentColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  final _roundBorder = const BoxDecoration(
    color: MyConstants.red,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
  );

  Widget _buildNFCView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.nfc_rounded, size: 256),
              if (!nfcRead) const CircularProgressIndicator(strokeWidth: 5),
            ],
          ),
          const SizedBox(height: MyConstants.formInputSpacer),
        ],
      ),
    );
  }
}
