import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/product_amount_card.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_list_tab.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProductsTab(
        user: widget.user,
        wrapper: (index, product) => ProductCounterCard(index: index, product: product),
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
                onPressed: () {},
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
