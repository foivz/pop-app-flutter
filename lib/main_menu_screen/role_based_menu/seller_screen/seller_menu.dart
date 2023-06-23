import 'package:pop_app/main_menu_screen/menu_screen_mixin.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/sales_menu.dart';

import 'package:flutter/material.dart';

class SellerMenu extends StatefulWidget {
  const SellerMenu({super.key});

  @override
  State<SellerMenu> createState() => _SellerMenuState();
}

class _SellerMenuState extends State<SellerMenu> with MenuScreenMixin {
  @override
  Widget build(BuildContext context) {
    return generateMenu(
      context: context,
      nameOfCustomOption: "Sell",
      customOptionScreen: const SalesMenuScreen(),
    );
  }
}
