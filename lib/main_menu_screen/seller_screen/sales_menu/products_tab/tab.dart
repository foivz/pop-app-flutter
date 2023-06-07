// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_card.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';

class ProductsTab extends StatelessWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return ListView.separated(
            itemCount: 20,
            shrinkWrap: true,
            clipBehavior: Clip.hardEdge,
            separatorBuilder: (context, index) => const Divider(
              indent: 3,
              endIndent: 3,
              thickness: 0, // linked to vertical symmetric padding above
            ),
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return ProductCard(index: index, productdata: snapshot.data as ProductData);
            },
          );
        else
          return const Center(child: CircularProgressIndicator());
      },
      future: ApiRequestManager.getAllProducts(SalesMenuScreen.of(context)!.widget.user!),
    );
  }
}
