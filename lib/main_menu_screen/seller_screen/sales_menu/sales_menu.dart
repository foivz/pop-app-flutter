import 'package:flutter/material.dart';

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
                Placeholder(),
                Placeholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
