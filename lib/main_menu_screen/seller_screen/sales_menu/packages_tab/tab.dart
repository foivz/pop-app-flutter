// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_card.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';

import 'package:flutter/material.dart';

class PackagesTab extends StatelessWidget {
  const PackagesTab({super.key});

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
              thickness: 0,
            ),
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return PackageCard(index: index, packageData: snapshot.data as PackageData);
            },
          );
        else
          return const Center(child: CircularProgressIndicator());
      },
      initialData: const PackageData(
        title: "Lemonade",
        description: "A pack of lemonade.",
        image: "Img",
        products: <ProductData>[
          ProductData(
            currency: "HRK",
            description: "Desc",
            image: "Img",
            price: 12.00,
            title: "Lemonade",
          ),
          ProductData(
            currency: "HRK",
            description: "Desc",
            image: "Img",
            price: 12.00,
            title: "Lemonade",
          ),
          ProductData(
            currency: "HRK",
            description: "Desc",
            image: "Img",
            price: 12.00,
            title: "Lemonade",
          ),
          ProductData(
            currency: "HRK",
            description: "Desc",
            image: "Img",
            price: 12.00,
            title: "Lemonade",
          ),
        ],
      ),
    );
  }
}
