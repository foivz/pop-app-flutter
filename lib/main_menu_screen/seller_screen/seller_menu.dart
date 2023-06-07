import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/main_menu_screen/wallet_screen/wallet_screen.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SellerMenu extends StatefulWidget {
  const SellerMenu({Key? key}) : super(key: key);

  @override
  State<SellerMenu> createState() => _SellerMenuState();
}

const double _iconSize = 148;

class _SellerMenuState extends State<SellerMenu> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = (clampDouble(width / _iconSize, 1, 4)).toInt();
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      children: [
        _buildButton('assets/icons/sell-icon.png', 'Sell', () {
          User.loggedIn.then((user) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return SalesMenuScreen(user: user);
            }));
          });
        }),
        _buildButton('assets/icons/view-icon.png', 'Invoices', () {}),
        _buildButton('assets/icons/wallet-icon.png', 'Wallet', () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalletScreen()));
        }),
        _buildButton('assets/icons/settings-icon.png', 'Settings', () {}),
      ],
    );
  }

  Widget _buildButton(String imagePath, String title, void Function() onPressedCallback) {
    return SizedBox(
      width: 20,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: const ButtonStyle(
            maximumSize: MaterialStatePropertyAll<Size>(Size(_iconSize, _iconSize)),
            backgroundColor: MaterialStatePropertyAll(MyConstants.accentColor),
            shape: MaterialStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
          onPressed: onPressedCallback,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: _iconSize - 16,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
