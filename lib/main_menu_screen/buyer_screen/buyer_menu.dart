import 'package:pop_app/main_menu_screen/buyer_screen/buying_dialog/buying_dialog.dart';
import 'package:pop_app/main_menu_screen/menu_screen_mixin.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class BuyerMenu extends StatefulWidget {
  const BuyerMenu({Key? key}) : super(key: key);

  @override
  State<BuyerMenu> createState() => _BuyerMenuState();
}

class _BuyerMenuState extends State<BuyerMenu> with MenuScreenMixin {
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
            context: context, nameOfCustomOption: "Buy", customOptionScreen: const BuyerDialog())
        : const CircularProgressIndicator();
  }
}
