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
  int _selectedForSelling = 1;

  int getRemainingAmount();

  set selectedForSelling(int newSelectedAmount) {
    if (newSelectedAmount > getRemainingAmount()) {
      throw Exception("Amount exceeded!");
    }
    _selectedForSelling = newSelectedAmount;
  }

  int get selectedForSelling => _selectedForSelling;

  /// Amount selected for putting this product into packages.
  int selectedForPackaging = 0;

  String get getPrice => price.toStringAsFixed(2);

  Item({
    this.id = "0",
    required this.title,
    required this.description,
    required this.price,
    this.imagePath,
    this.imageFile,
  });
}
