import 'dart:io';

abstract class Item {
  String id;
  late String title;
  late String description;
  late double price;

  // Uploaded image path.
  final String? imagePath;

  // New image file.
  File? imageFile;

  /// Amount selected for selling.
  int _selectedAmount = 1;

  int getMaxAvailableAmount();

  void setSelectedAmount(int newSelectedAmount) {
    if (newSelectedAmount > getMaxAvailableAmount()) {
      throw Exception("Amount exceeded!");
    }
    _selectedAmount = newSelectedAmount;
  }

  int getSelectedAmount() {
    return _selectedAmount;
  }

  String getPrice() {
    return price.toStringAsFixed(2);
  }

  Item({
    this.id = "0",
    required this.title,
    required this.description,
    required this.price,
    this.imagePath,
    this.imageFile,
  });
}
