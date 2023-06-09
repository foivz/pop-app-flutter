import 'dart:io';

abstract class ProductData {
  final int id;
  int get quantity => -1;
  const ProductData(this.id);
}

class ConstantProductData extends ProductData {
  final String title;
  final String description;
  final double price;
  final String? currency;
  final String? imagePath;
  final File? imageFile;
  final int amount;
  const ConstantProductData(
    super.id, {
    required this.title,
    required this.description,
    required this.price,
    this.currency,
    this.imagePath,
    this.imageFile,
    this.amount = 1,
  });
}

class VariableProductData extends ConstantProductData {
  int _variedAmount = 0;

  VariableProductData(
    super.id, {
    required super.title,
    required super.description,
    required super.price,
    super.currency,
    super.imagePath,
    super.imageFile,
    super.amount = 1,
  }) {
    _variedAmount = 0;
  }

  VariableProductData.withProduct(ConstantProductData product)
      : super(
          product.id,
          title: product.title,
          description: product.description,
          amount: product.amount,
          price: product.price,
          currency: product.currency,
          imageFile: product.imageFile,
          imagePath: product.imagePath,
        ) {
    _variedAmount = 0;
  }

  @override
  int get quantity => _variedAmount;

  set quantity(int value) {
    if (value >= 0) _variedAmount = value;
  }
}
