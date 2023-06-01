import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/main_menu_screen/seller_screen/seller_menu.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';
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
    bool isBottomSheetActive = false;
    return Scaffold(
      key: mainMenuKey,
      appBar: AppBar(
        title: Text("Welcome, ${role.name}!"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              if (isBottomSheetActive == false) {
                (mainMenuKey.currentState as ScaffoldState).showBottomSheet(
                  (BuildContext context) {
                    return Container(
                      height: 200,
                      color: MyConstants.accentColor2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('BottomSheet',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(color: Colors.white)),
                            FormSubmitButton(
                              buttonText: "Logout",
                              type: FormSubmitButtonStyle.OUTLINE,
                              onPressed: () {
                                Navigator.pop(context);
                                isBottomSheetActive = false;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                isBottomSheetActive = true;
              }
            },
          ),
        ],
      ),
      body: role == UserRoleType.seller ? sellerMenu : buyerMenu,
    );
  }
}
