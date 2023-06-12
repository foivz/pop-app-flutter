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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    "Make sure the seller is ready to sell the product!",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: MyConstants.formInputSpacer * 4),
                FormSubmitButton(
                  buttonText: 'Scan the QR Code',
                  color: MyConstants.accentColor2,
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return const QRScannerScreen();
                    })).then((value) => value is bool ? null : Navigator.pop(context));
                  },
                ),
                const SizedBox(height: MyConstants.formInputSpacer),
                const LineWithText(lineText: 'or'),
                const SizedBox(height: MyConstants.formInputSpacer),
                FormSubmitButton(
                  buttonText: 'Enter code to purchase',
                  color: MyConstants.accentColor2,
                  type: FormSubmitButtonStyle.OUTLINE,
                  onPressed: () async {
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
                  },
                ),
              ],
            ),
          ),
        ),
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
