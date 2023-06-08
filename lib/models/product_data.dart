import 'package:pop_app/models/item.dart';

class ProductData extends Item {
  final double price;
  final String currency;
  final int amount;

  ProductData({
    id = 0,
    required title,
    required description,
    required image,
    required this.price,
    required this.currency,
    this.amount = 1,
  }) : super(id: id, title: title, description: description, image: image);
}