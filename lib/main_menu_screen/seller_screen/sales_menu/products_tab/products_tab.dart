// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/models/product_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_card.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';

import '../items_tab.dart';

class ProductsTab extends StatefulWidget with ItemsTab {
  ProductsTab({super.key});

  @override
  State<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductData> products =
              PackageDataApiInterface.productsFromApi(snapshot.data!.last["DATA"]);
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
              return ProductCard(
                index: index,
                productdata: products[index],
                onSelected: widget.handleItemSelection,
              );
            },
          );
        } else
          return const Center(child: CircularProgressIndicator());
      },
      future: ApiRequestManager.getAllProducts(SalesMenuScreen.of(context)!.widget.user!),
    );
  }
}
