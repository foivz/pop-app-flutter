import 'package:pop_app/main_menu_screen/drawer.dart';
import 'package:pop_app/main_menu_screen/seller_screen/seller_menu.dart';
import 'package:flutter/material.dart';

enum UserRole { buyer, seller }

class MainMenuScreen extends StatelessWidget {
  final UserRole role;
  const MainMenuScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    const SellerMenu sellerMenu = SellerMenu();
    const Widget buyerMenu = Placeholder();
    GlobalKey mainMenuKey = GlobalKey();
    return Scaffold(
      key: mainMenuKey,
      appBar: AppBar(
        title: Text("Welcome, ${role.name}!"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                (mainMenuKey.currentState as ScaffoldState).openEndDrawer();
              }),
        ],
      ),
      body: role == UserRole.seller ? sellerMenu : buyerMenu,
      endDrawer: const MainMenuDrawer(),
    );
  }
}
