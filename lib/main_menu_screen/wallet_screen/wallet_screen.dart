import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/secure_storage.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isWalletDataLoaded = false;
  double balanceAmount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAndShowBalance();
  }

  void _fetchAndShowBalance() async {
    // TODO: Think about using the User class for storing all user info.
    var decodedUserInfo = json.decode(await SecureStorage.getUserData());
    User user = User.username(username: decodedUserInfo["KorisnickoIme"]);
    user.setRole(
        User.roles.firstWhere((role) => role.roleId == int.parse(decodedUserInfo["Id_Uloge"])));

    try {
      var fetchedBalance = await ApiRequestManager.getBalance(user);
      setState(() {
        isWalletDataLoaded = true;
        balanceAmount = fetchedBalance;
      });
    } on Exception catch (e) {
      if (context.mounted) {
        Message.error(context).show(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Wallet")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: !isWalletDataLoaded
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Balance",
                                style: TextStyle(fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text("$balanceAmount 💸"),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
