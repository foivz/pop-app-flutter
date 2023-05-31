import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

class ProductCard extends Card {
  final int index;
  final ProductData productdata;
  const ProductCard({super.key, required this.index, required this.productdata});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {},
      splashColor: MyConstants.red,
      focusColor: MyConstants.red.withOpacity(0.4),
      borderRadius: BorderRadius.circular(16),
      highlightColor: MyConstants.red.withOpacity(0.4),
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 10,
        borderOnForeground: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Image.asset(
              'assets/icons/view-icon.png',
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.colorBurn,
              height: 128,
              width: width * 0.2,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              width: width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productdata.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                  ),
                  Text(productdata.description, overflow: TextOverflow.fade),
                ],
              ),
            ),
            Text(
              "${productdata.price} ${productdata.currency}",
              style: const TextStyle(color: MyConstants.accentColor),
            ),
          ]),
        ),
      ),
    );
  }
}
