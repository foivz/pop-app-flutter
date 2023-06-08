import 'package:pop_app/models/item.dart';

mixin ItemsTab {
  final List<Item> selectedItems = List.empty(growable: true);

  void handleItemSelection(isSelected, productData) {
    if (isSelected) {
      selectedItems.add(productData);
    } else {
      selectedItems.remove(productData);
    }
  }
}
