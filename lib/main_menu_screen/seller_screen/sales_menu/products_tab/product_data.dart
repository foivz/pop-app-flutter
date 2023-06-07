class ProductData {
  final String title;
  final String description;
  final double price;
  final String currency;
  final String image;
  final int amount;
  const ProductData({
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    this.amount = 1,
  });
}
