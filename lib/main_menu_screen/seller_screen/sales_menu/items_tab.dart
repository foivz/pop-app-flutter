import 'package:flutter/material.dart';
import 'package:pop_app/models/item.dart';

abstract class ItemsTab extends StatefulWidget {
  final Function(bool isSelected) onSelectionStateChange;
  final List<Item> selectedItems = List.empty(growable: true);

  ItemsTab(this.onSelectionStateChange, {super.key});

  void handleItemSelection(isSelected, productData) {
    if (isSelected) {
      selectedItems.add(productData);
    } else {
      selectedItems.remove(productData);
    }
    onSelectionStateChange(isSelected);
  }
}
