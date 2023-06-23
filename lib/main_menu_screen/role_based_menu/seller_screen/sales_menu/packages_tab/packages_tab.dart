// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/widgets/item_card.dart';
import 'package:pop_app/utils/api_requests.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/models/package_data.dart';

import '../widgets/items_tab.dart';

class PackagesTab extends ItemsTab {
  PackagesTab({super.key, required super.onSelectionStateChange});

  @override
  State<PackagesTab> createState() => _PackagesTabState();
}

class _PackagesTabState extends State<PackagesTab> {
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
              return ItemCard(
                index: index,
                item: PackageDataApiInterface.fromAPI((snapshot.data!.last["DATA"] as List)[index]),
                onSelected: widget.handleItemSelection,
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
