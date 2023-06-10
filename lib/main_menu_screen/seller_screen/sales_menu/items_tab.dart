import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/user.dart';

abstract class ItemsTab extends StatefulWidget {
  final Function(bool isSelected) onSelectionStateChange;
  final List<Item> selectedItems = List.empty(growable: true);

  final User user;
  final GlobalKey<SalesMenuScreenState> salesMenuKey;

  ItemsTab(
      {super.key,
      required this.user,
      required this.salesMenuKey,
      required this.onSelectionStateChange});

  void handleItemSelection(isSelected, productData) {
    HapticFeedback.selectionClick();
    if (isSelected) {
      selectedItems.add(productData);
    } else {
      selectedItems.remove(productData);
    }
    onSelectionStateChange(isSelected);
  }
}
