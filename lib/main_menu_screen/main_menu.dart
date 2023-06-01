import 'package:pop_app/main_menu_screen/seller_screen/seller_menu.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';
import 'dart:ui';

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
                    int crossAxisCount = MediaQuery.of(context).size.width ~/ 200;
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        color: MyConstants.red,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(height: MyConstants.formInputSpacer),
                          GridView.count(
                              crossAxisCount: clampDouble(crossAxisCount.toDouble(), 1, 2).toInt(),
                              shrinkWrap: true,
                              childAspectRatio: 3.5,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                FormSubmitButton(
                                  buttonText: "Logout",
                                  type: FormSubmitButtonStyle.FILL,
                                  color: MyConstants.accentColor2,
                                  highlightColor: MyConstants.accentColor,
                                  onPressed: () {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                    isBottomSheetActive = false;
                                  },
                                ),
                                FormSubmitButton(
                                  buttonText: "Cancel",
                                  color: MyConstants.accentColor2,
                                  type: FormSubmitButtonStyle.OUTLINE,
                                  highlightColor: MyConstants.accentColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    isBottomSheetActive = false;
                                  },
                                ),
                              ]),
                        ],
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
