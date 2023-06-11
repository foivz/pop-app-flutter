import 'package:flutter/material.dart';
import 'package:pop_app/models/item.dart';

class AvailableProducts extends ChangeNotifier {
  final List<Item> _items = [];

  void addAll(List<Item> items) {
    _items.addAll(items);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }

  void removeById(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void edit(Item item) {
    removeById(item.id);
    _items.add(item);
    notifyListeners();
  }

  int getLength() => _items.length;

  Item getElement(int index) => _items[index];

  List<Item> getSelectedForPackaging() =>
      _items.where((element) => element.selectedForPackaging > 0).toList();

  List<Item> getSelectedForSelling() =>
      _items.where((element) => element.selectedForSelling > 0).toList();
}
