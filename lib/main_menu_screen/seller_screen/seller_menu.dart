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
        _buildButton('assets/icons/settings-icon.png', 'Settings'),
        _buildButton('assets/icons/wallet-icon.png', 'Wallet'),
        _buildButton('assets/icons/view-icon.png', 'View'),
      ],
    );
  }

  Widget _buildButton(String imagePath, String title) {
    double width = 128;

    return Container(
      color: MyConstants.accentColor,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {},
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                imagePath,
                width: width - 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
