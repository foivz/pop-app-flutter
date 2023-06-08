abstract class Item {
  String id;
  late String title;
  late String description;
  late String image;

  Item({this.id = "0", required this.title, required this.description, required this.image});
}
