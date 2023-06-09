// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_card.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/user.dart';

import 'package:flutter/material.dart';

class PackagesTab extends StatelessWidget {
  final User user;
  final GlobalKey<SalesMenuScreenState> salesMenuKey;
  const PackagesTab({super.key, required this.user, required this.salesMenuKey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data!.last["DATA"].length,
            shrinkWrap: true,
            clipBehavior: Clip.hardEdge,
            separatorBuilder: (_, __) => const Divider(indent: 3, endIndent: 3, thickness: 0),
            padding: const EdgeInsets.all(5),
            itemBuilder: (context, index) {
              return PackageCard(
                index: index,
                user: user,
                salesMenuKey: salesMenuKey,
                package:
                    PackageDataApiInterface.fromAPI((snapshot.data!.last["DATA"] as List)[index]),
              );
            },
          );
        } else
          return const Center(child: CircularProgressIndicator());
      },
      future: ApiRequestManager.getAllPackages(),
    );
  }
}
