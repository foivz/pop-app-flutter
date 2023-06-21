import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/invoice_details_screen/invoice_details_screen.dart';
import 'package:pop_app/models/invoice.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class NFCScreen extends StatefulWidget {
  const NFCScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  bool codeScanned = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
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
      backgroundColor: MyConstants.red,
      body: _buildQrView(context),
      bottomSheet: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: MyConstants.red,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Text(
          !codeScanned ? "Scan a seller's QR code" : "Processing scanned code...",
          style: TextStyle(color: !codeScanned ? Colors.white : MyConstants.accentColor),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (!codeScanned) {
        setState(() {
          codeScanned = true;
        });
        attemptToFinalizeInvoice(scanData.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
