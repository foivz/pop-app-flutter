import 'package:pop_app/models/item.dart';

class ProductData extends Item {
  final int amount;

  // Quantity of this product in a new package that's being created.
  int quantity = 0;

  ProductData({
    super.id,
    required super.title,
    required super.description,
    required this.amount,
    this.quantity = 0,
    super.imagePath,
    super.imageFile,
    super.price = 0,
  });

  @override
  int getMaxAvailableAmount() => amount;
}
