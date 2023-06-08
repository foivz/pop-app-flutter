// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/add_product_screen.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/tab.dart';

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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    loadTabContents();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<SalesMenuScreenState> key = GlobalKey<SalesMenuScreenState>();
    return Scaffold(
      key: key,
      appBar: AppBar(title: const Text("Entrepreneurial Venture"), actions: [
        IconButton(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              if (await showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Scaffold(body: CreateStoreContent(salesMenuKey: key, user: widget.user)),
                  );
                },
              )) setState(() {});
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
    setState(() {
      tabContents = [
        ProductsTab(user: widget.user),
        PackagesTab(user: widget.user),
      ];
    });
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const <Tab>[
            Tab(text: "PRODUCTS"),
            Tab(text: "PACKAGES"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: tabContents,
          ),
        ),
      ],
    );
  }
}
