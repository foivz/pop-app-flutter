import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/tab.dart';

class SalesMenuScreen extends StatefulWidget {
  const SalesMenuScreen({super.key});

  @override
  State<SalesMenuScreen> createState() => _SalesMenuScreenState();
}

class _SalesMenuScreenState extends State<SalesMenuScreen> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrepreneurial Venture")), // TODO: load shop name instead
      body: Column(
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
      ),
    );
  }
}
