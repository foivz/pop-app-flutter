import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/user.dart';

abstract class ItemsTab extends StatefulWidget {
  final Function(bool isSelected)? onSelectionStateChange;
  final List<Item> selectedItems = List.empty(growable: true);

  final User user;

  ItemsTab({
    super.key,
    required this.user,
    this.onSelectionStateChange,
  });

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
