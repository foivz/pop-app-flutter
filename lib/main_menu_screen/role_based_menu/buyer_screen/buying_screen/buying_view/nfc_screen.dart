import 'dart:convert';

import 'package:pop_app/main_menu_screen/invoices_screen/invoice_details_screen/invoice_details_screen.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:pop_app/models/invoice.dart';
import 'package:pop_app/utils/api_requests.dart';
import 'package:pop_app/utils/myconstants.dart';
// import 'package:ndef/ndef.dart' as ndef; // TODO: uncomment this when implementing NFC

import 'package:flutter/material.dart';

class BuyerNFCScreen extends StatefulWidget {
  const BuyerNFCScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BuyerNFCScreenState();
}

class _BuyerNFCScreenState extends State<BuyerNFCScreen> {
  @override
  void initState() {
    super.initState();
    _initNFC(scaffoldKey);
  }

  bool nfcFound = false;
  void _initNFC(key) async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      if (context.mounted) {
        try {
          Message.error(context).show("NFC is not available on this device.", scaffoldKey: key);
        } catch (e) {
          print(e);
        }
        Navigator.pop(context, false);
      }
    } else {
      var tag = await FlutterNfcKit.poll(
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag",
      );
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

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: const Text("Payment via NFC")),
      body: _buildNFCView(context),
      bottomSheet: Container(
        width: double.infinity,
        decoration: _roundBorder,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          !nfcFound ? "Touch your device to the seller's device." : "Processing...",
          style: TextStyle(color: !nfcFound ? Colors.white : MyConstants.accentColor),
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
          Stack(alignment: Alignment.center, children: [
            const Icon(Icons.nfc_rounded, size: 256),
            if (!nfcFound) const CircularProgressIndicator(strokeWidth: 5)
          ]),
          const SizedBox(height: MyConstants.formInputSpacer),
        ],
      ),
    );
  }
}
