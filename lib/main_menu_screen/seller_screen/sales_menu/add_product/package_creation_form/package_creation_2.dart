import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/product_amount_card.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_list_tab.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      body: ProductsTab(
        key: productsTabKey,
        user: widget.user,
        wrapper: (index, product) =>
            ProductCounterCard(index: index, productsTabKey: productsTabKey),
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
                  for (var product in productsTabKey.currentState!.products.where((p) {
                    return p.quantity > 0;
                  })) {
                    if (product.quantity > 0) {
                      ids.add(product.id);
                      amounts.add(product.quantity);
                    }
                  }
                  int packageId = int.parse(
                      ((await ApiRequestManager.getAllPackages()).last["DATA"] as List).last["Id"]);
                  ApiRequestManager.addProductsToPackage(ids, amounts, packageId);
                },
              ),
              const SizedBox(height: MyConstants.submitButtonHeight / 4),
              FormSubmitButton(
                buttonText: "Back",
                type: FormSubmitButtonStyle.OUTLINE,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
