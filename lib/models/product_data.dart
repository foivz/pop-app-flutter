import 'package:pop_app/models/item.dart';

class ProductData extends Item {
  final int remainingAmount;

  // Quantity of this product in a new package that's being created.
  int amountInNewPackage = 0;

  ProductData({
    super.id,
    required super.title,
    required super.description,
    required this.remainingAmount,
    this.amountInNewPackage = 0,
    super.imagePath,
    super.imageFile,
    super.price = 0,
  });

  @override
  int getRemainingAmount() => remainingAmount;
}
