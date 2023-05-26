import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/seller_menu.dart';
import 'package:pop_app/myconstants.dart';

enum UserRole { buyer, seller }

class MainMenuScreen extends StatelessWidget {
  final UserRole role;
  const MainMenuScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    const SellerMenu sellerMenu = SellerMenu();
    const Widget buyerMenu = Placeholder();
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome, ${role.name}!"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(icon: const Icon(Icons.person), onPressed: () {}),
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          ],
        ),
        body: role == UserRole.seller ? sellerMenu : buyerMenu);
  }
}
