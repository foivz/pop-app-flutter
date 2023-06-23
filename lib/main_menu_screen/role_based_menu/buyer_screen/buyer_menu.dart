import 'package:pop_app/main_menu_screen/role_based_menu/buyer_screen/buying_screen/buying_screen.dart';
import 'package:pop_app/main_menu_screen/menu_screen_mixin.dart';

import 'package:flutter/material.dart';

class BuyerMenu extends StatefulWidget {
  const BuyerMenu({Key? key}) : super(key: key);

  @override
  State<BuyerMenu> createState() => _BuyerMenuState();
}

class _BuyerMenuState extends State<BuyerMenu> with MenuScreenMixin {
  @override
  Widget build(BuildContext context) {
    return generateMenu(
      context: context,
      nameOfCustomOption: "Buy",
      customOptionScreen: const BuyingScreen(),
    );
  }
}
