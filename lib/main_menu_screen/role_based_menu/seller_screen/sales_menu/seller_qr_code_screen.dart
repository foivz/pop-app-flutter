import 'package:pop_app/reusable_components/form_submit_button_widget.dart';
import 'package:pop_app/reusable_components/line_with_text_widget.dart';
import 'package:pop_app/models/initial_invoice.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pop_app/utils/myconstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellerQRCodeScreen extends StatelessWidget {
  final InitialInvoice invoice;
  const SellerQRCodeScreen(this.invoice, {super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormSubmitButtonState> invoiceKey = GlobalKey();
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
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ..._qrCode(context),
              ..._invoiceInfo(context, invoiceKey: invoiceKey),
              ..._exitNotice(context),
            ]),
          ),
        ),
      ),
    );
  }

  List<Widget> _qrCode(BuildContext context) {
    var style = Theme.of(context).textTheme.titleLarge?.copyWith(color: MyConstants.accentColor2);
    return [
      Text("Scan the code below", style: style),
      const SizedBox(height: MyConstants.formInputSpacer),
      QrImageView(data: invoice.id, size: 200), // generates QR code
    ];
  }

  List<Widget> _invoiceInfo(BuildContext context, {GlobalKey<FormSubmitButtonState>? invoiceKey}) {
    return [
      Text("Invoice ID: ${invoice.id}"),
      const SizedBox(height: MyConstants.formInputSpacer / 2),
      const LineWithText(
        lineText: 'or',
        lineColor: MyConstants.accentColor2,
        textColor: MyConstants.accentColor2,
      ),
      const SizedBox(height: MyConstants.formInputSpacer / 2),
      Text(
        "Enter the code below",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: MyConstants.accentColor2),
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormSubmitButton(
        key: invoiceKey,
        color: MyConstants.accentColor2,
        type: FormSubmitButtonStyle.OUTLINE,
        buttonText: invoice.code,
        onPressed: () => Share.shareWithResult(invoice.code),
      ),
    ];
  }

  List<Widget> _exitNotice(BuildContext context) {
    return [
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
    ];
  }
}
