// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/product_data.dart';

class PackageData extends Item implements PackageDataApiInterface {
  final double discount;
  double priceAfterDiscount = 0;

  final List<ProductData> products;

  get count => products.length;
  get itemCount => _itemCount();

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
    for (var product in products) sum += product.price;
    return sum;
  }

  int _itemCount() {
    int sum = 0;
    for (ProductData product in products) sum += product.amount;
    return sum;
  }

  @override
  int getMaxAvailableAmount() {
    int maxAmount = 0;
    for (ProductData product in products) {
      if (maxAmount == 0 || maxAmount > product.amount) {
        maxAmount = product.amount;
      }
    }
    return maxAmount;
  }
}

abstract class PackageDataApiInterface {
  static PackageData fromAPI(dynamic data) {
    var dat = data.first;
    return PackageData(
      id: dat["Id"],
      title: dat["Naziv"],
      description: dat["Opis"],
      discount: double.parse(dat["Popust"]),
      priceAfterDiscount: double.parse(dat["CijenaStavkeNakonPopusta"]),
      products: productsFromApi(dat["StavkePaketa"]),
      imagePath: dat["Slika"],
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
        amount: int.parse(product["Kolicina"]),
      ));
    }
    return products;
  }
}
