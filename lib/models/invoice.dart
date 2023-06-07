import 'package:pop_app/models/invoice_item.dart';

class Invoice {
  String? id;
  String? locationOfFinalization;
  String? dateOfFinalization;
  String? storeId;
  String? storeName;
  String? buyerId;
  String? buyerFirstName;
  String? buyerLastName;
  String? username;
  String? price;
  String? discount;
  String? discountAmount;
  String? finalPrice;
  List<InvoiceItem>? items;

  Invoice(
      {id,
      mjestoIzdavanja,
      datumIzdavanja,
      idTrgovine,
      trgovina,
      kupac,
      imeKlijenta,
      prezimeKlijenta,
      korisnickoIme,
      cijenaRacuna,
      popustRacuna,
      iznosPopustaRacuna,
      zavrsnaCijena,
      stavke});

  /// Intended for deserialized JSON.
  Invoice.fromDynamicMap(Map<String, dynamic> json) {
    id = json['Id'];
    locationOfFinalization = json['MjestoIzdavanja'];
    dateOfFinalization = json['DatumIzdavanja'];
    storeId = json['Id_Trgovine'];
    storeName = json['Trgovina'];
    buyerId = json['Kupac'];
    buyerFirstName = json['Ime_Klijenta'];
    buyerLastName = json['Prezime_Klijenta'];
    username = json['KorisnickoIme'];
    price = json['CijenaRacuna'];
    discount = json['PopustRacuna'];
    discountAmount = json['IznosPopustaRacuna'];
    finalPrice = json['ZavrsnaCijena'];
    if (json['Stavke'] != null) {
      items = <InvoiceItem>[];
      json['Stavke'].forEach((v) {
        items!.add(InvoiceItem.fromDynamicMap(v));
      });
    }
  }
}
