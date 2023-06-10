import 'package:pop_app/main_menu_screen/menu_screen_mixin.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/models/user.dart';

import 'package:flutter/material.dart';

class SellerMenu extends StatefulWidget {
  const SellerMenu({Key? key}) : super(key: key);

  @override
  State<SellerMenu> createState() => _SellerMenuState();
}

class _SellerMenuState extends State<SellerMenu> with MenuScreenMixin {
  User? user;

  @override
  void initState() {
    User.loggedIn.then((user) => {setState(() => this.user = user)});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? generateMenu(
            context: context,
            nameOfCustomOption: "Sell",
            customOptionScreen: SalesMenuScreen(user: user!))
        : const CircularProgressIndicator();
  }
}
