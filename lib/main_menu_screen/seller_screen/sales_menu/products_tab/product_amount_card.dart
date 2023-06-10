// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/items_tab.dart';
import 'package:pop_app/models/product_data.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class ProductCounterCard extends StatefulWidget {
  final int index;
  final GlobalKey<ItemsTab> productsTabKey;
  const ProductCounterCard({super.key, required this.index, required this.productsTabKey});

  @override
  State<ProductCounterCard> createState() => _ProductCounterCardState();
}

class _ProductCounterCardState extends State<ProductCounterCard> {
  late ProductData product;

  @override
  void initState() {
    super.initState();
    product = widget.productsTabKey.currentState!.selectedItems[widget.index] as ProductData;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: _rectangleBorderDecoration(),
          child: _card(width),
        ),
      ],
    );
  }

  BoxDecoration _rectangleBorderDecoration() {
    return BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: MyConstants.red),
    );
  }

  Image _image(double width) {
    return Image.network(
      product.imagePath ?? "",
      height: 128,
      width: width * 0.2,
    );
  }

  Card _card(double width) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 10,
      borderOnForeground: true,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: Row(children: [
          _image(width),
          _productText(width),
          Column(
            children: [
              _price(),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () =>
                            setState(() => product.quantity >= 1 ? product.quantity-- : null),
                      ),
                      Text(
                        product.quantity.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: MyConstants.accentColor2),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () => setState(() => product.quantity++),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  Container _productText(double width) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      width: width * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
          ),
          Text(product.description, overflow: TextOverflow.fade),
        ],
      ),
    );
  }

  Text _price() {
    return Text(
      product.price.toString(),
      style: const TextStyle(color: MyConstants.accentColor),
    );
  }
}
