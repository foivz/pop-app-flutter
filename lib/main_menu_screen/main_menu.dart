import 'package:pop_app/main_menu_screen/buyer_screen/buyer_menu.dart';
import 'package:pop_app/main_menu_screen/seller_screen/seller_menu.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/profile_screen/profile.dart';

enum UserRole { buyer, seller }

class MainMenuScreen extends StatelessWidget {
  final UserRole role;
  const MainMenuScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    const SellerMenu sellerMenu = SellerMenu();
    const Widget buyerMenu = BuyerMenu();
    GlobalKey mainMenuKey = GlobalKey();
    return Scaffold(
      key: mainMenuKey,
      appBar: AppBar(
        title: Text("Welcome, ${role.name}!"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: role == UserRole.seller ? sellerMenu : buyerMenu,
    );
  }
}
