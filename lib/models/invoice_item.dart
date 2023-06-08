class InvoiceItem {
  late String id;
  late String name;
  late String description;
  late String itemUrl;
  late String quantity;
  late String itemType;
  late String price;

  /// Price of the item multiplied by amount.
  late String totalPrice;

  InvoiceItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.itemUrl,
      required this.quantity,
      required this.itemType,
      required this.price,
      required this.totalPrice});

  /// Intended for deserialized JSON.
  InvoiceItem.fromDynamicMap(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Naziv'];
    description = json['Opis'];
    itemUrl = json['Slika'];
    quantity = json['Kolicina'];
    itemType = json['ItemType'];
    price = json['Cijena'];
    totalPrice = json['CijenaStavke'];
  }
}
