// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/store_content_creation.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_list_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_list_tab.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/models/user.dart';

class SalesMenuScreen extends StatefulWidget {
  final User user;
  const SalesMenuScreen({super.key, required this.user});

  static SalesMenuScreenState? of(BuildContext context) {
    try {
      return context.findAncestorStateOfType<SalesMenuScreenState>();
    } catch (err) {
      return null;
    }
  }

  @override
  State<SalesMenuScreen> createState() => SalesMenuScreenState();
}

class SalesMenuScreenState extends State<SalesMenuScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    loadTabContents();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  GlobalKey<SalesMenuScreenState> thisMenuKey = GlobalKey<SalesMenuScreenState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: thisMenuKey,
      appBar: AppBar(title: const Text("Entrepreneurial Venture"), actions: [
        IconButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Scaffold(
                        body: StoreContentCreation(salesMenuKey: thisMenuKey, user: widget.user)),
                  );
                },
              ).then((value) {
                if (value is bool) loadTabContents();
              });
            });
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () => setState(() {}),
          icon: const Icon(Icons.attach_money),
        ),
      ]),
      body: tabs(),
    );
  }

  List<Widget> tabContents = List.empty(growable: true);
  void loadTabContents() {
    setState(() => tabContents = [Container()]);
    setState(
      () => tabContents = [
        ProductsTab(user: widget.user, salesMenuKey: thisMenuKey),
        PackagesTab(user: widget.user, salesMenuKey: thisMenuKey),
      ],
    );
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          tabs: const <Tab>[
            Tab(text: "PRODUCTS"),
            Tab(text: "PACKAGES"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: tabContents,
          ),
        ),
      ],
    );
  }
}
