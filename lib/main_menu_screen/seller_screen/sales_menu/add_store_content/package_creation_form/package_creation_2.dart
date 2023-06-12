// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:pop_app/api_requests.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/item_card.dart';
import 'package:pop_app/models/available_products.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:provider/provider.dart';

class PackageCreation2 extends StatefulWidget {
  final GlobalKey productListKey;
  const PackageCreation2({super.key, required this.productListKey});

  @override
  State<PackageCreation2> createState() => _PackageCreation2State();
}

class _PackageCreation2State extends State<PackageCreation2> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AvailableProducts>(builder: (context, products, child) {
      return Scaffold(
        body: ListView.separated(
          itemCount: products.getLength(),
          shrinkWrap: true,
          clipBehavior: Clip.none,
          separatorBuilder: (context, index) => const Divider(
            indent: 3,
            endIndent: 3,
            thickness: 0, // linked to vertical symmetric padding above
          ),
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {
            Item currentItem = products.getElement(index);
            return ItemCard(
              index: index,
              item: currentItem,
              onSelectedAmountChange: (newAmount) {
                if (newAmount >= 0) products.getElement(index).selectedForPackaging = newAmount;
              },
              startAmount: 0,
            );
          },
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

                    var selectedItems = products.getSelectedForPackaging();

                    for (var product in selectedItems) {
                      ids.add(int.parse(product.id));
                      // TODO: verify that it loads the right amount
                      amounts.add(product.selectedForPackaging);
                    }

                    // a fix would be to make the api return the id of the newly created package
                    int packageId = int.parse(
                        ((await ApiRequestManager.getAllPackages()).last["DATA"] as List)
                            .last["Id"]);

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
    });
  }
}
