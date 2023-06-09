import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/main_menu.dart';
import 'package:pop_app/models/user.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatelessWidget {
  final String invoiceId;
  const QRCodeScreen(this.invoiceId, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.maybePop(context);
        User user = await User.loggedIn;
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MainMenuScreen(role: UserRoleType.seller, username: user.username),
            ),
          );
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Finalize invoice")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Please, scan the code below."),
            QrImageView(
              data: invoiceId,
              size: 200,
            ),
            Text("Invoice ID: $invoiceId"),
            const Text("Exit this screen once the buyer has scanned the code.")
          ]),
        ),
      ),
    );
  }
}
