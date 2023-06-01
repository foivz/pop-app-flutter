// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';

class PackageData {
  final String title;
  final String description;
  final List<ProductData> products;
  get price => _price();
  get currency => _currency();
  get count => products.length;
  const PackageData({required this.title, required this.description, required this.products});
  String _currency() {
    if (products.isEmpty) throw Exception('No products in package $title.');
    String currency = products.first.currency;
    for (var product in products)
      if (product.currency != currency)
        throw Exception('Currency ${product.currency} does not match $currency.');
    return currency;
  }

  double _price() {
    _currency();
    double sum = 0.0;
    for (var product in products) {
      sum += product.price;
    }
    return sum;
  }
}
