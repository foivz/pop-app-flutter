// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/package_creation_form/package_creation_1.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/package_creation_form/package_creation_2.dart';

import 'package:flutter/material.dart';

class PackageCreationTab extends StatefulWidget {
  final GlobalKey productListKey;

  const PackageCreationTab({
    super.key,
    required this.productListKey,
  });

  static PackageCreationTabState? of(BuildContext context) {
    try {
      return context.findAncestorStateOfType<PackageCreationTabState>();
    } catch (err) {
      return null;
    }
  }

  @override
  State<PackageCreationTab> createState() => PackageCreationTabState();
}

class PackageCreationTabState extends State<PackageCreationTab> with AutomaticKeepAliveClientMixin {
  late PackageCreation2 packageCreation2;
  @override
  void initState() {
    super.initState();
    packageCreation2 = PackageCreation2(productListKey: widget.productListKey);
  }

  bool showBottomSheet = false;

  void showProductSelectionScreen() => setState(() => showBottomSheet = true);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (showBottomSheet)
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          showModalBottomSheet(
            context: context,
            builder: (_) => packageCreation2,
            isScrollControlled: true,
            useSafeArea: true,
          ).then((value) {
            Navigator.pop(context, true);
          });
        },
      );
    return const Scaffold(
      backgroundColor: Colors.white,
      body: PackageCreation1(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
