import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pop_app/models/item.dart';

abstract class ItemsTab extends StatefulWidget {
  final Function(bool isSelected)? onSelectionStateChange;
  final List<Item> selectedItems = List.empty(growable: true);

  ItemsTab({super.key, this.onSelectionStateChange});

  void handleItemSelection(isSelected, productData) {
    HapticFeedback.selectionClick();
    if (isSelected) {
      selectedItems.add(productData);
    } else {
      selectedItems.remove(productData);
    }
    onSelectionStateChange?.call(isSelected);
  }
}
