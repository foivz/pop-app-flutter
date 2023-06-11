// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/item_card.dart';
import 'package:pop_app/models/available_products.dart';
import 'package:pop_app/models/package_data.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/item.dart';
import '../items_tab.dart';

class ProductsTab extends ItemsTab {
  final int startAmount;

  ProductsTab({
    super.key,
    required super.user,
    super.onSelectionStateChange,
    this.startAmount = 1,
  });

  @override
  State<ProductsTab> createState() => ProductsTabState();
}

class ProductsTabState extends State<ProductsTab> {
  bool noItemsForUser = false;

  @override
  void initState() {
    _storeProductsInProvider();
    super.initState();
  }

  void _storeProductsInProvider() async {
    AvailableProducts provider = Provider.of<AvailableProducts>(context, listen: false);
    var receivedData = await ApiRequestManager.getAllProducts(widget.user);
    if (receivedData.last["STATUSMESSAGE"] == "OK, NO PRODUCTS") {
      setState(() {
        noItemsForUser = true;
      });
    }
    List<Item> items = PackageDataApiInterface.productsFromApi(receivedData.last["DATA"]);
    provider.removeAll();
    provider.addAll(items);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AvailableProducts>(builder: (context, products, child) {
      if (noItemsForUser) {
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
      } else if (products.getLength() > 0) {
        return ListView.separated(
          itemCount: products.getLength(),
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
              item: products.getElement(index),
              onSelected: widget.handleItemSelection,
              onSelectedAmountChange: null,
              startAmount: widget.startAmount,
            );
          },
        );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
