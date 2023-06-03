import 'package:pop_app/main_menu_screen/seller_screen/seller_menu.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/profile_screen/profile.dart';

enum UserRoleType { buyer, seller }

class MainMenuScreen extends StatelessWidget {
  final UserRoleType role;
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
      body: role == UserRoleType.seller ? sellerMenu : buyerMenu,
    );
  }
}
