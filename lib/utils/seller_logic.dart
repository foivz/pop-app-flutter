import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/available_products.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/models/user.dart';
import 'package:provider/provider.dart';

void refreshAllProducts(BuildContext context, User user, {Function? onNoItems}) async {
  AvailableProducts provider = Provider.of<AvailableProducts>(context, listen: false);
  var receivedData = await ApiRequestManager.getAllProducts(user);
  if (receivedData.last["STATUSMESSAGE"] == "OK, NO PRODUCTS") {
    onNoItems?.call();
  }
  List<Item> items = PackageDataApiInterface.productsFromApi(receivedData.last["DATA"]);
  provider.removeAll();
  provider.addAll(items);
}
