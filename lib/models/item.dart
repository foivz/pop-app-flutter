abstract class Item {
  String id;
  late String title;
  late String description;
  late String image;
  late double price;

  String getPrice() {
    return price.toStringAsFixed(2);
  }

  Item({
    this.id = "0",
    required this.title,
    required this.description,
    required this.image,
    required this.price,
  });
}
