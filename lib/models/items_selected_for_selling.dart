import 'package:flutter/material.dart';
import 'package:pop_app/models/item.dart';

class ItemsSelectedForSelling extends ChangeNotifier {
  late final List<Item> _items;

  ItemsSelectedForSelling(List<Item> selectedItems) {
    _items = selectedItems;
  }

  List<Item> get selectedItems => _items;

  void addSelectedProduct(Item selectedItem) {
    _items.add(selectedItem);
    notifyListeners();
  }

  void changeProductAmount(int index, int newAmount) {
    selectedItems[index].selectedForSelling = newAmount;
    notifyListeners();
  }
}
