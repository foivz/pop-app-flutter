import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/myconstants.dart';

class MainMenuDrawer extends Drawer {
  const MainMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 180,
      backgroundColor: MyConstants.red,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 48),
        child: Stack(children: [
          _drawerContentTop(),
          _logout(),
        ]),
      ),
    );
  }

  Column _drawerContentTop() {
    return Column(
      children: [
        _opt(Icons.person, "Profile", () {}),
        _opt(Icons.settings, "Settings", () {}),
        _opt(Icons.wallet, "Wallet", () {}),
        _opt(Icons.receipt, "Invoices", () {}),
      ],
    );
  }

  Widget _logout() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FormSubmitButton(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.logout, color: Colors.white),
        ),
        mainAxisAlignment: MainAxisAlignment.start,
        buttonText: "Log out",
        onPressed: () {},
      ),
    );
  }

  FormSubmitButton _opt(IconData icon, String buttonText, void Function() onPressed) {
    return FormSubmitButton(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: Colors.white),
      ),
      mainAxisAlignment: MainAxisAlignment.start,
      buttonText: buttonText,
      onPressed: onPressed,
    );
  }
}
