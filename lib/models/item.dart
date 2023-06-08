abstract class Item {
  String id;
  late String title;
  late String description;
  late String image;
  late double price;

  /// Amount selected for selling.
  int _selectedAmount = 0;

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
    required this.image,
    required this.price,
  });
}
