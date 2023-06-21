import 'package:pop_app/main_menu_screen/buyer_screen/buying_screen/nfc_screen.dart';
import 'package:pop_app/main_menu_screen/buyer_screen/buying_screen/qr_scanner_screen.dart';
import 'package:pop_app/invoice_details_screen/invoice_details_screen.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/login_screen/linewithtext_widget.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class BuyingScreen extends StatelessWidget {
  const BuyingScreen({super.key});

  final String _qrLabel = "Scan QR Code", _nfcLabel = "NFC payment", _enterCodeLabel = "Enter code";
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
                _header(context),
                const SizedBox(height: MyConstants.formInputSpacer * 4),
                _btn(_qrLabel, null, () => _qrCode(context)),
                const SizedBox(height: MyConstants.formInputSpacer),
                _btn(_nfcLabel, null, () => _nfc(context)),
                ...or,
                _btn(_enterCodeLabel, FormSubmitButtonStyle.OUTLINE, () => _enterCode(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FormSubmitButton _btn(String label, FormSubmitButtonStyle? type, void Function() onPressed) {
    return FormSubmitButton(
      buttonText: label,
      color: label == _nfcLabel ? MyConstants.accentColor : MyConstants.accentColor2,
      highlightColor: label == _nfcLabel ? MyConstants.accentColor2 : MyConstants.accentColor,
      type: type ?? FormSubmitButtonStyle.FILL,
      onPressed: onPressed,
    );
  }

  SizedBox _header(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        "Make sure the seller is ready to sell the product!",
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  final List or = const [
    SizedBox(height: MyConstants.formInputSpacer),
    LineWithText(lineText: 'or'),
    SizedBox(height: MyConstants.formInputSpacer),
  ];

  void _qrCode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const QRScannerScreen();
    })).then((value) => value is bool ? null : Navigator.pop(context));
  }

  void _nfc(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const NFCScreen();
    })).then((value) => value is bool ? null : Navigator.pop(context));
  }

  void _enterCode(BuildContext context) {
    TextEditingController codeCont = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Purchase via code'),
        content: SizedBox(
          height: MyConstants.submitButtonHeight,
          child: Center(
            child: Form(
              child: CustomTextFormField(
                inputLabel: "Enter code",
                textEditingController: codeCont,
                autoFocus: true,
              ),
            ),
          ),
        ),
        surfaceTintColor: Colors.white,
        actions: <Widget>[
          TextButton(
            child: const Text('Confirm purchase'),
            onPressed: () => finalizeInvoiceViaInput(codeCont.text, context),
          ),
        ],
      ),
    );
  }

  void finalizeInvoiceViaInput(String codeInput, BuildContext context) {
    try {
      ApiRequestManager.finalizeInvoiceViaCode(codeInput).then((invoice) {
        if (invoice != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return InvoiceDetailsScreen(invoice);
          }), result: true);
        } else {
          Message.error(context).show("Something went wrong, try again.");
        }
      });
    } on FormatException {
      Message.error(context).show("You cannot proceed with this invoice.");
      Navigator.pop(context, false);
    } catch (e) {
      Message.error(context).show(e.toString());
    }
  }
}
