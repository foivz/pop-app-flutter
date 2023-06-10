// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:pop_app/api_requests.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/products_tab.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/message.dart';

class PackageCreation2 extends StatefulWidget {
  final GlobalKey productListKey;
  final User user;
  const PackageCreation2({
    super.key,
    required this.user,
    required this.productListKey,
  });

  @override
  State<PackageCreation2> createState() => _PackageCreation2State();
}

class _PackageCreation2State extends State<PackageCreation2> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ProductsTabState> productsTabKey = GlobalKey<ProductsTabState>();
    return Scaffold(
      body: ProductsTab(
        key: productsTabKey,
        user: widget.user,
        onAmountStateChange: () {
          // TODO: declare callback
          print("amount changed");
        },
        startAmount: 0,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 15),
        height: MyConstants.submitButtonHeight * 2 + MyConstants.formInputSpacer * 2 + 3,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Center(
          child: Column(
            children: [
              FormSubmitButton(
                key: widget.productListKey,
                buttonText: "Add products to package",
                color: MyConstants.accentColor2,
                onPressed: () async {
                  List<int> ids = List.empty(growable: true);
                  List<int> amounts = List.empty(growable: true);
                  for (var product
                      in (productsTabKey.currentWidget! as ProductsTab).selectedItems.where((p) {
                    return p.selectedAmount > 0;
                  })) {
                    if (product.selectedAmount > 0) {
                      ids.add(int.parse(product.id));
                      amounts.add(
                          product.selectedAmount); // TODO: verify that it load sthe right amount
                    }
                  }
                  int packageId = int.parse(
                      ((await ApiRequestManager.getAllPackages()).last["DATA"] as List).last["Id"]);
                  bool success =
                      await ApiRequestManager.addProductsToPackage(ids, amounts, packageId);
                  if (success) {
                    Message.info(context).show("Successfully added products to package.");
                    Navigator.pop(context, true);
                  } else
                    Message.error(context)
                        .show("Connection failure. Check your internet and try again.");
                },
              ),
              const SizedBox(height: MyConstants.submitButtonHeight / 4),
              FormSubmitButton(
                buttonText: "Skip",
                type: FormSubmitButtonStyle.OUTLINE,
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
