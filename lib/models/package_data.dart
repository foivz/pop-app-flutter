// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/product_data.dart';

class PackageData extends Item implements PackageDataApiInterface {
  final double discount;
  double priceAfterDiscount = 0;

  final List<ProductData> products;

  PackageData({
    super.id,
    required super.title,
    required super.description,
    required this.products,
    required this.discount,
    priceAfterDiscount,
    super.imagePath,
    super.imageFile,
    super.price = 0,
  }) {
    super.price = _price();

    // In case an API returns price after discount, use that (backend's) number.
    // Otherwise, calculate it here.
    if (priceAfterDiscount != null) {
      this.priceAfterDiscount = priceAfterDiscount;
    } else {
      this.priceAfterDiscount = price - price * discount;
    }
  }

  double _price() {
    double sum = 0.0;
    for (var product in products) sum += product.price * product.getRemainingAmount();
    sum = sum - sum * discount / 100;
    return sum;
  }

  @override
  int getRemainingAmount() {
    int amountOfProductsInPackage = 0;
    for (ProductData product in products) {
      amountOfProductsInPackage += product.getRemainingAmount();
    }
    return amountOfProductsInPackage;
  }
}

abstract class PackageDataApiInterface {
  static PackageData fromAPI(Map data) {
    return PackageData(
      id: data["Id"],
      title: data["Naziv"],
      description: data["Opis"],
      discount: double.parse(data["Popust"]),
      priceAfterDiscount: double.parse(data["CijenaStavkeNakonPopusta"]),
      products: productsFromApi(data["StavkePaketa"]),
      imagePath: data["Slika"],
    );
  }

  static List<ProductData> productsFromApi(dynamic productList) {
    List<ProductData> products = List.empty(growable: true);
    for (var product in productList) {
      products.add(ProductData(
        id: product["Id"],
        title: product["Naziv"],
        description: product["Opis"],
        price: double.parse(product["Cijena"]),
        imagePath: product["Slika"],
        remainingAmount: int.parse(product["Kolicina"]),
      ));
    }
    return products;
  }
}
