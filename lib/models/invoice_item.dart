class InvoiceItem {
  String? id;
  String? name;
  String? description;
  String? itemUrl;
  String? amount;
  String? itemType;
  String? price;

  /// Price of the item multiplied by amount.
  String? totalPrice;

  InvoiceItem(
      {this.id,
      this.name,
      this.description,
      this.itemUrl,
      this.amount,
      this.itemType,
      this.price,
      this.totalPrice});

  /// Intended for deserialized JSON.
  InvoiceItem.fromDynamicMap(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Naziv'];
    description = json['Opis'];
    itemUrl = json['Slika'];
    amount = json['Kolicina'];
    itemType = json['ItemType'];
    price = json['Cijena'];
    totalPrice = json['CijenaStavke'];
  }
}
