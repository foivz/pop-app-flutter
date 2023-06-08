import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/item_card.dart';
import 'package:pop_app/models/item.dart';

class SellItemsScreen extends StatefulWidget {
  final List<Item> selectedItems;
  const SellItemsScreen(this.selectedItems, {super.key});

  @override
  State<SellItemsScreen> createState() => _SellItemsScreenState();
}

class _SellItemsScreenState extends State<SellItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice generation")),
      body: ListView.separated(
        itemCount: widget.selectedItems.length,
        shrinkWrap: true,
        clipBehavior: Clip.hardEdge,
        separatorBuilder: (context, index) => const Divider(
          indent: 3,
          endIndent: 3,
          thickness: 0, // linked to vertical symmetric padding above
        ),
        padding: const EdgeInsets.all(5),
        itemBuilder: (context, index) {
          Item currentItem = widget.selectedItems[index];
          return ItemCard(index: index, item: currentItem);
        },
      ),
    );
  }
}
