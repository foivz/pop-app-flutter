import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

class SellerMenu extends StatefulWidget {
  const SellerMenu({Key? key}) : super(key: key);

  @override
  State<SellerMenu> createState() => _SellerMenuState();
}

class _SellerMenuState extends State<SellerMenu> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        _buildButton('assets/icons/sell-icon.png', 'Sell'),
        _buildButton('assets/icons/view-icon.png', 'Invoices'),
        _buildButton('assets/icons/wallet-icon.png', 'Wallet'),
        _buildButton('assets/icons/settings-icon.png', 'Settings'),
      ],
    );
  }

  Widget _buildButton(String imagePath, String title) {
    double width = 128;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(MyConstants.accentColor),
          shape: MaterialStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: width - 16,
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
    );
  }
}
