// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';

import 'dart:io';

class PackageData implements PackageDataApiInterface {
  final String title;
  final String description;
  final String? image;
  final File? imageFile;
  final double discount;
  final double? priceAfterDiscount;
  final List<ProductData> products;

  /// Calculates total price of products included.
  get price => _price();

  /// Calculates count of products included.
  get count => products.length;

  /// Calculates total item count based on all products included.
  get itemCount => _itemCount();

  const PackageData({
    required this.title,
    required this.description,
    this.image,
    this.imageFile,
    required this.products,
    required this.discount,
    this.priceAfterDiscount,
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
    return PackageData(
      title: data["Naziv"],
      description: data["Opis"],
      discount: double.parse(data["Popust"]),
      priceAfterDiscount: double.parse(data["CijenaStavkeNakonPopusta"]),
      products: productsFromApi(data["StavkePaketa"] as List),
      image: data["Slika"],
    );
  }

  static List<ProductData> productsFromApi(List? productList) {
    List<ProductData> products = List.empty(growable: true);
    if (productList == null || productList.isEmpty) {
      return products;
    }
    for (var product in productList) {
      products.add(ProductData(
        title: product["Naziv"],
        description: product["Opis"],
        price: double.parse(product["Cijena"]),
        currency: product["Naziv"],
        imagePath: product["Slika"],
        amount: int.parse(product["Kolicina"]),
      ));
    }
    return products;
  }
}
