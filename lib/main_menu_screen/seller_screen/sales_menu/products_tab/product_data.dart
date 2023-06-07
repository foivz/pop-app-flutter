import 'dart:io';

class ProductData {
  final String title;
  final String description;
  final double price;
  final String? currency;
  final String? imagePath;
  final File? imageFile;
  final int amount;
  const ProductData({
    required this.title,
    required this.description,
    required this.price,
    this.currency,
    this.imagePath,
    this.imageFile,
    this.amount = 1,
  });
}
