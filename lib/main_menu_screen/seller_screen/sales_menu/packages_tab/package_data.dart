// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';

class PackageData implements PackageDataApiInterface {
  final String title;
  final String description;
  final String image;
  final double discount;
  final double priceAfterDiscount;
  final List<ProductData> products;

  get price => _price();
  get count => products.length;
  get itemCount => _itemCount();

  const PackageData({
    required this.title,
    required this.description,
    required this.image,
    required this.products,
    required this.discount,
    required this.priceAfterDiscount,
  });

  double _price() {
    double sum = 0.0;
    for (var product in products) sum += product.price;
    return sum;
  }

  int _itemCount() {
    int sum = 0;
    for (ProductData product in products) sum += product.amount;
    return sum;
  }
}

abstract class PackageDataApiInterface {
  static PackageData fromAPI(dynamic data) {
    var dat = data.first;
    return PackageData(
      title: dat["Naziv"],
      description: dat["Opis"],
      discount: double.parse(dat["Popust"]),
      priceAfterDiscount: double.parse(dat["CijenaStavkeNakonPopusta"]),
      products: productsFromApi(dat["StavkePaketa"]),
      image: dat["Slika"],
    );
  }

  static List<ProductData> productsFromApi(dynamic productList) {
    List<ProductData> products = List.empty(growable: true);
    for (var product in productList) {
      products.add(ProductData(
        title: product["Naziv"],
        description: product["Opis"],
        price: double.parse(product["Cijena"]),
        currency: product["Naziv"],
        image: product["Slika"],
        amount: int.parse(product["Kolicina"]),
      ));
    }
    return products;
  }
}
