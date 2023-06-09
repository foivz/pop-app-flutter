// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/product_creation_form/product_creation_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/message.dart';

class ProductCard extends StatefulWidget {
  final int index;
  final ConstantProductData product;

  final GlobalKey<SalesMenuScreenState> salesMenuKey;
  final User user;

  const ProductCard({
    super.key,
    required this.index,
    required this.product,
    required this.salesMenuKey,
    required this.user,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animCont;

  bool isSelected = false;

  void select() {
    HapticFeedback.selectionClick();
    setState(() {
      isSelected = !isSelected;
      if (isSelected)
        _animCont.forward();
      else
        _animCont.reverse();
    });
  }

  void showOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                "Product options",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_square, color: Colors.white),
              title: const Text('Edit product', style: TextStyle(color: Colors.white)),
              onTap: edit,
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white),
              title: const Text('Delete product', style: TextStyle(color: Colors.white)),
              onTap: () {
                delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void delete() {
    HapticFeedback.vibrate();
    ApiRequestManager.deleteProduct(widget.product.id).then((value) {
      SalesMenuScreen.of(context)!.loadTabContents();
      SalesMenuScreen.of(context)!.tabController.index = 0;
    }).catchError((e) {
      Message.error(context).show("Connection failure. Check your internet and try again.");
    });
  }

  Future<void> edit() async {
    HapticFeedback.selectionClick();
    GlobalKey<ProductCreationTabState> productEditTab = GlobalKey<ProductCreationTabState>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ProductCreationTab(
          key: productEditTab,
          salesMenuKey: widget.salesMenuKey,
          user: widget.user,
          product: widget.product,
          submitButtonLabel: "Submit changes",
          onSubmit: () {
            formElements() => productEditTab.currentState!.formElements();
            imageProd() => productEditTab.currentState!.productImage;
            var form = (formElements()[StoreContentType.Product]![ProductFormElements.formKey]
                as GlobalKey<FormState>);
            form.currentState!.validate();
            try {
              ConstantProductData product = ConstantProductData(
                widget.product.id,
                title: formElements()[StoreContentType.Product]![ProductFormElements.nameCont].text,
                description:
                    formElements()[StoreContentType.Product]![ProductFormElements.descCont].text,
                price: double.parse(
                    formElements()[StoreContentType.Product]![ProductFormElements.priceCont].text),
                amount: int.parse(
                    formElements()[StoreContentType.Product]![ProductFormElements.quantityCont]
                        .text),
                imageFile: imageProd(),
              );
              ApiRequestManager.editProduct(product).then((response) {
                if (response.statusCode == 200) {
                  Message.info(context).show(
                    "Saved changes for ${formElements()[StoreContentType.Product]![ProductFormElements.nameCont].text} to store.",
                  );
                  SalesMenuScreen.of(context)!.loadTabContents();
                  SalesMenuScreen.of(context)!.tabController.index = 0;
                  Navigator.pop(context, true);
                } else
                  Message.error(context).show(
                    "Failed to submit changes for ${formElements()[StoreContentType.Product]![ProductFormElements.nameCont].text} to store.",
                  );
              }).catchError((error) {
                Message.error(context)
                    .show("Connection failure. Check your internet and try again.");
              });
            } catch (e) {
              Message.error(context).show("Not all fields are filled.");
            }
          },
        );
      },
    );
    return;
  }

  @override
  void initState() {
    super.initState();
    _animCont = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        InkWell(
          onTap: select,
          onLongPress: showOptions,
          splashColor: MyConstants.red,
          focusColor: MyConstants.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          highlightColor: MyConstants.red.withOpacity(0.4),
          child: _card(width),
        ),
        _selectionMarker(),
      ],
    );
  }

  Align _selectionMarker() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(padding: const EdgeInsets.all(12.0), child: _animatedSelectionMarker()),
    );
  }

  AnimatedWidget _animatedSelectionMarker() {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_animCont),
      child: ScaleTransition(
        scale: Tween(begin: 0.0, end: 1.0).animate(_animCont),
        child: _iconWithBorder(),
      ),
    );
  }

  Container _iconWithBorder() => Container(decoration: _circleBorderDecoration(), child: _icon());

  BoxDecoration _circleBorderDecoration() {
    return BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: isSelected ? MyConstants.red : Colors.grey, width: 3),
    );
  }

  Icon _icon() {
    return Icon(color: isSelected ? MyConstants.red : Colors.grey, Icons.attach_money);
  }

  Image _image(double width) {
    return Image.network(
      widget.product.imagePath ?? "",
      height: 128,
      width: width * 0.2,
    );
  }

  Card _card(double width) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 10,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          _image(width),
          _productText(width),
          _price(),
        ]),
      ),
    );
  }

  Container _productText(double width) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      width: width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
          ),
          Text(widget.product.description, overflow: TextOverflow.fade),
        ],
      ),
    );
  }

  Text _price() {
    return Text(
      widget.product.price.toString(),
      style: const TextStyle(color: MyConstants.accentColor),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
