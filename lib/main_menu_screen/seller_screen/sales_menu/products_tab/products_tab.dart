// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/item_card.dart';
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/models/product_data.dart';

import 'package:flutter/material.dart';

import '../items_tab.dart';

class ProductsTab extends ItemsTab {
  final Function()? onAmountStateChange;
  final int startAmount;
  ProductsTab({
    super.key,
    required super.user,
    super.onSelectionStateChange,
    this.onAmountStateChange,
    this.startAmount = 1,
  });

  @override
  State<ProductsTab> createState() => ProductsTabState();
}

class ProductsTabState extends State<ProductsTab> {
  List<ProductData> products = List.empty(growable: true);
  @override
  Widget build(BuildContext context) {
    GlobalKey<ProductsTabState> productsTabStateKey = GlobalKey<ProductsTabState>();
    return FutureBuilder(
      key: productsTabStateKey,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.last["STATUSMESSAGE"] == "OK, NO PRODUCTS") {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "It's empty in here...\n"
                  "How about using that + sign in the top right corner?",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          }
          products = PackageDataApiInterface.productsFromApi(snapshot.data!.last["DATA"]);
          return ListView.separated(
            itemCount: products.length,
            shrinkWrap: true,
            clipBehavior: Clip.hardEdge,
            separatorBuilder: (context, index) => const Divider(
              indent: 3,
              endIndent: 3,
              thickness: 0, // linked to vertical symmetric padding above
            ),
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return ItemCard(
                index: index,
                item: products[index],
                onSelected: widget.handleItemSelection,
                onAmountChange: widget.onAmountStateChange,
                startAmount: widget.startAmount,
              );
            },
          );
        } else
          return const Center(child: CircularProgressIndicator());
      },
      future: ApiRequestManager.getAllProducts(widget.user),
    );
  }
}
