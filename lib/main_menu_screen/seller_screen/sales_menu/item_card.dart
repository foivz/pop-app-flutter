// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/services.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/package_creation_form/package_creation_1.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/product_creation_form/product_creation_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/message.dart';

class ItemCard extends StatefulWidget {
  final int index;
  final Item item;
  final Function(bool isSelected, Item item)? onSelected;
  final GlobalKey<SalesMenuScreenState> salesMenuKey;

  /// Only works if 'onAmountChange' callback is set.
  final int amountSelected = 1;
  final Function()? onAmountChange;
  const ItemCard({
    super.key,
    required this.index,
    required this.item,
    required this.salesMenuKey,
    this.onSelected,
    this.onAmountChange,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animCont;

  bool isSelected = false;

  void select() {
    if (widget.onSelected != null && widget.item.getMaxAvailableAmount() > 0) {
      setState(() {
        isSelected = !isSelected;
        widget.onSelected!.call(isSelected, widget.item);
        if (isSelected)
          _animCont.forward();
        else
          _animCont.reverse();
      });
    } else if (widget.onSelected != null && widget.item.getMaxAvailableAmount() <= 0) {
      Message.error(context).show("Sorry, but you don't have any ${widget.item.title} in stock.");
    }
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

  void showOptions(BuildContext context, StoreContentType itemType, String id) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
               "$itemType options",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_square, color: Colors.white),
              title: Text('Edit $itemType', style: const TextStyle(color: Colors.white)),
              onTap: () {
                switch (itemType) {
                  case StoreContentType.Product:
                    editProduct(context,itemType);
                    break;
                  case StoreContentType.Package:
                    editPackage(context, itemType);
                    break;
                  default:
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white),
              title: Text('Delete $itemType', style: const TextStyle(color: Colors.white)),
              onTap: () {
                switch (itemType) {
                  case StoreContentType.Product:
                    deletePackage(
                      context,
                      id
                    );
                    break;
                  case StoreContentType.Package:
                    deleteProduct(context, id);
                    break;
                  default:
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void deletePackage(BuildContext context, String packageId) {
    HapticFeedback.vibrate();
    ApiRequestManager.deletePackage(packageId).then((value) {
      SalesMenuScreen.of(context)!.loadTabContents();
      SalesMenuScreen.of(context)!.tabController.index = 1;
    }).catchError((e) {
      Message.error(context).show("Connection failure. Check your internet and try again.");
    });
  }

  void deleteProduct(BuildContext context, String productId) {
    HapticFeedback.vibrate();
    ApiRequestManager.deleteProduct(productId).then((value) {
      SalesMenuScreen.of(context)!.loadTabContents();
      SalesMenuScreen.of(context)!.tabController.index = 0;
    }).catchError((e) {
      Message.error(context).show("Connection failure. Check your internet and try again.");
    });
  }

    Future<void> editProduct(BuildContext context, StoreContentType itemType) async {
    HapticFeedback.selectionClick();
    GlobalKey<ProductCreationTabState> productEditTab = GlobalKey<ProductCreationTabState>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ProductCreationTab(
          key: productEditTab,
          salesMenuKey: widget.salesMenuKey,
          product: widget.item as ProductData,
          submitButtonLabel: "Submit changes",
          onSubmit: () {
            formElements() => productEditTab.currentState!.formElements();
            imageProd() => productEditTab.currentState!.productImage;
            var form = (formElements()[StoreContentType.Product]![ProductFormElements.formKey]
                as GlobalKey<FormState>);
            if (!form.currentState!.validate()) {
              Message.error(context).show("Not all fields are filled.");
              return;
            }
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

              if (product.title.contains("'") || product.description.contains("'")) {
                Message.error(context)
                    .show("Do not use ' character in your title and description!");
                return;
              }

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

  Future<void> editPackage(BuildContext context, StoreContentType itemType) async {
    HapticFeedback.selectionClick();
    GlobalKey<PackageCreation1State> packageEditTab = GlobalKey<PackageCreation1State>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return itemType == StoreContentType.Package ? PackageCreation1(
          key: packageEditTab,
          package: widget.item,
          submitButtonLabel: "Submit changes",
          onSubmit: () {
            formElements() => packageEditTab.currentState!.formElements();
            imagePack() => packageEditTab.currentState!.packageImage;
            var form = (formElements()[StoreContentType.Package]![PackageFormElements.formKey]
                as GlobalKey<FormState>);
            if (!form.currentState!.validate()) {
              Message.error(context).show("Not all fields are filled.");
              return;
            }
            try {
              PackageData package = PackageData(
                id: widget.item.id,
                products: [],
                title: formElements()[StoreContentType.Package]![PackageFormElements.nameCont].text,
                description:
                    formElements()[StoreContentType.Package]![PackageFormElements.descCont].text,
                discount: double.parse(
                    formElements()[StoreContentType.Package]![PackageFormElements.discountCont]
                        .text),
                imageFile: imagePack(),
              );

              if (package.title.contains("'") || package.description.contains("'")) {
                Message.error(context)
                    .show("Do not use ' character in your title and description!");
                return;
              }

              ApiRequestManager.editPackage(package).then((response) {
                if (response.statusCode == 200) {
                  Message.info(context).show(
                    "Saved changes for ${formElements()[StoreContentType.Package]![PackageFormElements.nameCont].text} to store.",
                  );
                  SalesMenuScreen.of(context)!.loadTabContents();
                  Navigator.pop(context, true);
                } else
                  Message.error(context).show(
                    "Failed to submit changes for ${formElements()[StoreContentType.Package]![PackageFormElements.nameCont].text} to store.",
                  );
              }).catchError((e) {
                Message.error(context)
                    .show("Connection failure. Check your internet and try again.");
              });
            } catch (e) {
              Message.error(context).show("Not all fields are filled.");
            }
          },
        ) : 
        // TODO productCreation
        ;
      },
    );
    return;
  }

  StoreContentType _getItemTypeOfCurrentItem() => widget.item is ProductData ? StoreContentType.Product : StoreContentType.Package;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        InkWell(
          onTap: select,
          onLongPress: () => showOptions(context, _getItemTypeOfCurrentItem(), widget.item.id),
          splashColor: MyConstants.red,
          focusColor: MyConstants.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          highlightColor: MyConstants.red.withOpacity(0.4),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            elevation: 10,
            borderOnForeground: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Image.network(
                  widget.item.image,
                  height: 128,
                  width: width * 0.2,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                      ),
                      Text(widget.item.description, overflow: TextOverflow.fade),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "💸\n${widget.item.getPrice()}",
                    style: const TextStyle(
                        color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animCont),
              child: ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(_animCont),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? MyConstants.red : Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    color: isSelected ? MyConstants.red : Colors.grey,
                    Icons.attach_money,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.onAmountChange != null)
          AmountSelector((newAmount) {
            widget.item.setSelectedAmount(newAmount);
            widget.onAmountChange!.call();
          })
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AmountSelector extends StatefulWidget {
  final Function(int newAmount) onAmountChange;
  const AmountSelector(this.onAmountChange, {super.key});

  @override
  State<AmountSelector> createState() => _AmountSelectorState();
}

class _AmountSelectorState extends State<AmountSelector> {
  int selectedAmount = 1;

  void changeAmount(bool increment) {
    if (increment || selectedAmount != 1) {
      setState(() {
        increment ? selectedAmount++ : selectedAmount--;
      });
      try {
        widget.onAmountChange(selectedAmount);
      } on Exception {
        setState(() {
          selectedAmount--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => changeAmount(false),
            icon: const Icon(
              Icons.remove_circle_sharp,
              color: MyConstants.red,
            ),
            iconSize: 35,
          ),
          Text(
            selectedAmount.toString(),
            style: TextStyle(
              fontSize: 25,
              color: Colors.grey.shade800,
            ),
          ),
          IconButton(
            onPressed: () => changeAmount(true),
            icon: const Icon(
              Icons.add_circle_outlined,
              color: MyConstants.red,
            ),
            iconSize: 35,
          ),
        ],
      ),
    );
  }
}
