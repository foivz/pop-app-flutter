import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/products_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/packages_tab.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sell_items_screen.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/reusable_components/message.dart';

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

class SalesMenuScreenState extends State<SalesMenuScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late final GlobalKey _sellIconKey = GlobalKey();
  late AnimationController _animCont;
  int _selectedItemsCount = 0;

  void onSelectionStateChange(bool isSelected) {
    setState(() {
      isSelected ? _selectedItemsCount++ : _selectedItemsCount--;
    });
    if (_selectedItemsCount > 0) {
      _animCont.forward();
    } else {
      _animCont.reverse();
    }
  }

  late ProductsTab productsTab;
  late PackagesTab packagesTab;

  @override
  void initState() {
    productsTab = ProductsTab(onSelectionStateChange);
    packagesTab = PackagesTab(onSelectionStateChange);
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animCont = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animCont.dispose();
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
        RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_animCont),
          child: ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(_animCont),
            child: IconButton(
              key: _sellIconKey,
              style: ButtonStyle(iconSize: MaterialStateProperty.resolveWith((states) => 40)),
              onPressed: () {
                List<Item> selectedItems = List.from(productsTab.selectedItems);
                selectedItems.addAll(packagesTab.selectedItems);

                if (selectedItems.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellItemsScreen(selectedItems),
                    ),
                  );
                } else {
                  Message.error(context).show(
                    "You can't sell products until you select them. Select products to sell them.",
                  );
                }
              },
              icon: const Icon(Icons.attach_money),
            ),
          ),
        )
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
