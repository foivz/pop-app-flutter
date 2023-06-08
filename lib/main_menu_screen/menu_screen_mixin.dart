import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/wallet_screen/wallet_screen.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

mixin MenuScreenMixin<T extends StatefulWidget> on State<T> {
  static const double iconSize = 148;

  Widget generateMenu({
    required BuildContext context,
    required String nameOfCustomOption,
    required Widget customOptionScreen,
  }) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = (clampDouble(width / MenuScreenMixin.iconSize, 1, 4)).toInt();
    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      children: [
        buildButton(context, 'assets/icons/sell-icon.png', nameOfCustomOption, () {
          User.loggedIn.then((user) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return customOptionScreen;
            }));
          });
        }),
        buildButton(context, 'assets/icons/view-icon.png', 'Invoices', () {}),
        buildButton(context, 'assets/icons/wallet-icon.png', 'Wallet', () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalletScreen()));
        }),
        buildButton(context, 'assets/icons/settings-icon.png', 'Settings', () {}),
      ],
    );
  }
}

SizedBox buildButton(
    BuildContext context, String imagePath, String title, void Function() onPressedCallback) {
  return SizedBox(
    width: 20,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: const ButtonStyle(
          maximumSize: MaterialStatePropertyAll<Size>(
              Size(MenuScreenMixin.iconSize, MenuScreenMixin.iconSize)),
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
              width: MenuScreenMixin.iconSize - 16,
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
