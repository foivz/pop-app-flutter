import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/store_content_creation/package_creation_form/package_creation_tab.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/store_content_creation/product_creation_form/product_creation_tab.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/tabs/products_tab/products_tab.dart';

import 'package:flutter/material.dart';

class StoreContentCreationMenu extends StatefulWidget {
  // 0 -> products, 1 -> packages
  final int selectedIndex;
  const StoreContentCreationMenu({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<StoreContentCreationMenu> createState() => _StoreContentCreationMenuState();
}

class _StoreContentCreationMenuState extends State<StoreContentCreationMenu>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<ProductsTabState> _productListKey = GlobalKey<ProductsTabState>();

  late TabController _tabController;
  late PackageCreationTab packageCreationForm;
  late ProductCreationTab productCreationForm;

  Widget tabs() {
    return Column(children: [
      Container(
        color: Colors.white,
        child: TabBar(
          padding: EdgeInsets.zero,
          controller: _tabController,
          tabs: const <Tab>[Tab(text: "Add product"), Tab(text: "Create package")],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [
            productCreationForm,
            packageCreationForm,
          ],
        ),
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.selectedIndex;
    packageCreationForm = PackageCreationTab(productListKey: _productListKey);
    productCreationForm = const ProductCreationTab();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(child: tabs());
  }

  @override
  bool get wantKeepAlive => true;
}
