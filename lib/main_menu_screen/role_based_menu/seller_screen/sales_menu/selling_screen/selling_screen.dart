import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/seller_qr_code_screen.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/selling_screen/nfc_screen.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/widgets/item_card.dart';
import 'package:pop_app/models/items_selected_for_selling.dart';
import 'package:pop_app/exceptions/printable_exception.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/models/initial_invoice.dart';
import 'package:pop_app/utils/api_requests.dart';
import 'package:pop_app/utils/myconstants.dart';
import 'package:pop_app/models/item.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SellItemsScreen extends StatefulWidget {
  const SellItemsScreen({super.key});

  @override
  State<SellItemsScreen> createState() => _SellItemsScreenState();
}

class _SellItemsScreenState extends State<SellItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsSelectedForSelling>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Invoice generation")),
          bottomSheet: const SellContent(),
          body: ListView.separated(
            itemCount: model.selectedItems.length,
            shrinkWrap: true,
            clipBehavior: Clip.none,
            separatorBuilder: (context, index) => const Divider(
              indent: 3,
              endIndent: 3,
              thickness: 0, // linked to vertical symmetric padding above
            ),
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 300),
            itemBuilder: (context, index) {
              Item currentItem = model.selectedItems[index];
              return ItemCard(
                index: index,
                item: currentItem,
                onSelectedAmountChange: (newAmount) {
                  model.changeProductAmount(index, newAmount);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class SellContent extends StatefulWidget {
  const SellContent({super.key});

  @override
  State<SellContent> createState() => _SellContentState();
}

class _SellContentState extends State<SellContent> {
  GlobalKey<FormFieldState>? discountInputKey = GlobalKey();
  TextEditingController discountInputCont = TextEditingController(text: "0");
  final double contentHeight = 140;

  void returnToNormalSize() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
  }

  String getTotalPrice(List<Item> selectedItems) {
    double totalPrice = 0;
    for (var item in selectedItems) {
      totalPrice += item.selectedForSelling * item.price;
    }

    double discount = 0;
    try {
      discount = double.parse(discountInputCont.text);
    } catch (e) {
      discountInputCont.text = "0";
    }

    if (discount != 0) totalPrice = totalPrice - totalPrice * discount / 100;

    return totalPrice.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsSelectedForSelling>(
      builder: (context, model, child) {
        return Container(
          height: contentHeight,
          decoration: _discountDeco,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Form(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 120, bottom: 16.0),
                  child: _discount(),
                ),
              ),
              _displayTotalAndMakeInvoice(model),
            ],
          ),
        );
      },
    );
  }

  Row _displayTotalAndMakeInvoice(ItemsSelectedForSelling model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ..._total(model),
        IconButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(MyConstants.accentColor2),
          ),
          iconSize: 40,
          icon: const Icon(Icons.start, color: Colors.white),
          onPressed: () => _generateInvoice(context, model),
        ),
      ],
    );
  }

  final BoxDecoration _discountDeco = const BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.elliptical(20, 10),
      topRight: Radius.elliptical(20, 10),
    ),
    color: MyConstants.red,
  );

  final Text _discountText = const Text(
    "DISCOUNT (%):",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

  Row _discount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _discountText,
        Container(
          width: 75,
          alignment: Alignment.topLeft,
          color: MyConstants.textfieldBackground,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: _discountInput(),
        ),
      ],
    );
  }

  TextFormField _discountInput() {
    return TextFormField(
      key: discountInputKey,
      controller: discountInputCont,
      inputFormatters: _inputFormatters,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(),
      textInputAction: TextInputAction.done,
      onTap: () => setState(() {}),
      onEditingComplete: returnToNormalSize,
      onTapOutside: (event) => returnToNormalSize(),
    );
  }

  final List<TextInputFormatter> _inputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
    _MaxValueInputFormatter(100),
  ];

  InputDecoration _inputDecoration() {
    return InputDecoration(
      floatingLabelStyle: MaterialStateTextStyle.resolveWith(
        (states) => const TextStyle(color: MyConstants.red, fontSize: 16),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: MyConstants.accentColor),
      ),
      contentPadding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
    );
  }

  final Text _totalText = const Text(
    "TOTAL:",
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
  );

  List<Widget> _total(ItemsSelectedForSelling model) {
    return [
      _totalText,
      Text(
        getTotalPrice(model.selectedItems),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      )
    ];
  }

  Future<void> _generateInvoice(BuildContext context, ItemsSelectedForSelling model) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initiate payment'),
        content: const Text('Confirm payment:'),
        surfaceTintColor: Colors.white,
        actions: <Widget>[
          TextButton(
            onPressed: () => _calculateInvoice(
              model: model,
              route: (initialInvoice) => SellerQRCodeScreen(invoice: initialInvoice),
            ),
            child: const Text('Payment via QR code'),
          ),
          FutureBuilder(
            future: FlutterNfcKit.nfcAvailability,
            builder: (builder, snapshot) {
              return TextButton(
                onPressed: () {
                  if (snapshot.hasData && snapshot.data == NFCAvailability.available) {
                    _calculateInvoice(
                      model: model,
                      route: (initialInvoice) => SellerNFCScreen(invoice: initialInvoice),
                    );
                  }
                },
                child: snapshot.hasData && snapshot.data == NFCAvailability.available
                    ? const Text('Payment via NFC')
                    : const Text('Payment via NFC', style: TextStyle(color: Colors.grey)),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _calculateInvoice({
    required ItemsSelectedForSelling model,
    required Widget Function(InitialInvoice) route,
  }) async {
    try {
      double discountAmount = double.parse(discountInputCont.text);
      InitialInvoice initialInvoice = await ApiRequestManager.generateInvoice(
        discountAmount,
        model.selectedItems,
      );
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route(initialInvoice)),
        );
      }
    } on Exception catch (ex, _) {
      Message.info(context).show(ex.message);
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }
}

class _MaxValueInputFormatter extends TextInputFormatter {
  final double maxValue;

  _MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    } else {
      double inputValue = double.tryParse(newValue.text) ?? 0.0;
      if (inputValue <= maxValue) {
        return newValue;
      } else {
        // Return the old value if the input is greater than the max value
        return oldValue;
      }
    }
  }
}
