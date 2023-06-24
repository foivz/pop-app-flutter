import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/buyer_screen/buying_screen/buying_view/nfc_screen.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/buyer_screen/buying_screen/buying_view/qr_scanner_screen.dart';
import 'package:pop_app/main_menu_screen/invoices_screen/invoice_details_screen/invoice_details_screen.dart';
import 'package:pop_app/reusable_components/form_submit_button_widget.dart';
import 'package:pop_app/reusable_components/form_text_input_field.dart';
import 'package:pop_app/reusable_components/line_with_text_widget.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/utils/api_requests.dart';
import 'package:pop_app/utils/myconstants.dart';

import 'package:flutter/material.dart';

class BuyingScreen extends StatefulWidget {
  const BuyingScreen({super.key});
  @override
  State<BuyingScreen> createState() => _BuyingScreenState();
}

class _BuyingScreenState extends State<BuyingScreen> {
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
                FutureBuilder(
                  future: FlutterNfcKit.nfcAvailability,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == NFCAvailability.available) {
                      return _btn(_nfcLabel, null, () => _nfc(context));
                    } else {
                      return _btn(_nfcLabel, null, () => _nfc(context), enabled: false);
                    }
                  },
                ),
                ...or,
                _btn(_enterCodeLabel, FormSubmitButtonStyle.OUTLINE, () => _enterCode(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormSubmitButtonState> _nfcBtnKey = GlobalKey<FormSubmitButtonState>();

  FormSubmitButton _btn(String label, FormSubmitButtonStyle? type, void Function() onPressed,
      {bool enabled = true}) {
    if (!enabled) _nfcBtnKey.currentState?.setEnabled(false);
    return FormSubmitButton(
      key: label == _nfcLabel ? _nfcBtnKey : null,
      buttonText: label,
      color: MyConstants.accentColor2,
      highlightColor: MyConstants.accentColor,
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
      return const BuyerQRScreen();
    })).then((value) => value is bool ? null : Navigator.pop(context));
  }

  void _nfc(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) {
          return const BuyerNFCScreen();
        }))
        .then((value) => value is bool ? null : Navigator.pop(context))
        .catchError((e) => Message.error(context).show("failure"));
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
              child: FormTextInputField(
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