import 'package:pop_app/models/invoice_item.dart';

class Invoice {
  late String id;
  late String locationOfFinalization;
  late String dateOfFinalization;
  late String storeId;
  late String storeName;
  late String buyerId;
  late String buyerFirstName;
  late String buyerLastName;
  late String username;
  late String price;
  late String discount;
  late String discountAmount;
  late String finalPrice;
  late List<InvoiceItem> items;

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
        items.add(InvoiceItem.fromDynamicMap(v));
      });
    }
  }
}
