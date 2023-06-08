import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/items_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/products_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/packages_tab.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sell_items_screen.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/user.dart';

class SalesMenuScreen extends StatefulWidget {
  final User? user;
  const SalesMenuScreen({super.key, this.user});

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
  late TabController _tabController;
  ProductsTab productsTab = ProductsTab();
  PackagesTab packagesTab = PackagesTab();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // TODO: load shop name instead
      appBar: AppBar(title: const Text("Entrepreneurial Venture"), actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {
            List<Item> selectedItems = List.from(productsTab.selectedItems);
            selectedItems.addAll(packagesTab.selectedItems);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SellItemsScreen(selectedItems),
              ),
            );
          },
          icon: const Icon(Icons.attach_money),
        ),
      ]),
      body: tabs(),
    );
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          padding: EdgeInsets.zero,
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: "PRODUCTS"),
            Tab(text: "PACKAGES"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              productsTab,
              packagesTab,
            ],
          ),
        ),
      ],
    );
  }
}
