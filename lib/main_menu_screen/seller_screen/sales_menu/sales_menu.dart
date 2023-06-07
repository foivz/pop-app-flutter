// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/add_product_screen.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/tab.dart';

import 'package:flutter/material.dart';
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
        IconButton(onPressed: _addStoreContent, icon: const Icon(Icons.add)),
        IconButton(onPressed: _addStoreContent, icon: const Icon(Icons.attach_money)),
      ]),
      body: tabs(),
    );
  }

  void _addStoreContent() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CreateStoreContent();
    }));
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
            children: const [
              ProductsTab(),
              PackagesTab(),
            ],
          ),
        ),
      ],
    );
  }
}
