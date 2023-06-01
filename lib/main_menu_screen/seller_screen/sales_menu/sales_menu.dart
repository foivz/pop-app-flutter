import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/tab.dart';

class SalesMenuScreen extends StatefulWidget {
  const SalesMenuScreen({super.key});

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
      appBar: AppBar(title: const Text("Entrepreneurial Venture")), // TODO: load shop name instead
      body: tabs(),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
        ),
        FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.attach_money),
        ),
      ]),
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
