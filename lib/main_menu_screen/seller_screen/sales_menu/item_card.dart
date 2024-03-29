// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/services.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/package_creation_form/package_creation_1.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/product_creation_form/product_creation_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/models/item.dart';
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/models/product_data.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/message.dart';

class ItemCard extends StatefulWidget {
  final int index;
  final Item item;
  final Function(bool isSelected, Item item)? onSelected;

  /// Only works if 'onSelectedAmountChange' callback is set.
  final int amountSelected = 1;
  final Function(int newAmount)? onSelectedAmountChange;
  final int startAmount;
  const ItemCard({
    super.key,
    required this.index,
    required this.item,
    this.onSelected,
    this.onSelectedAmountChange,
    this.startAmount = 1,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animCont;

  bool isSelected = false;

  void select() {
    if (widget.onSelected != null && widget.item.getRemainingAmount() > 0) {
      setState(() {
        isSelected = !isSelected;
        widget.onSelected?.call(isSelected, widget.item);
        if (isSelected)
          _animCont.forward();
        else
          _animCont.reverse();
      });
    } else if (widget.onSelected != null && widget.item.getRemainingAmount() <= 0) {
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
    String type = itemType == StoreContentType.Package ? "Package" : "Product";
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$type options",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            ListTile(
              leading: const Icon(Icons.edit_square, color: Colors.white),
              title: Text('Edit $type', style: const TextStyle(color: Colors.white)),
              onTap: () {
                switch (itemType) {
                  case StoreContentType.Product:
                    editProduct(context);
                    break;
                  case StoreContentType.Package:
                    editPackage(context);
                    break;
                  default:
                }
              },
            ),
            if (!isSelected)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: Text('Delete $type', style: const TextStyle(color: Colors.white)),
                onTap: () {
                  switch (itemType) {
                    case StoreContentType.Product:
                      deleteProduct(context, id);
                      break;
                    case StoreContentType.Package:
                      deletePackage(context, id);
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

  void deleteProduct(BuildContext context, String productId) {
    HapticFeedback.vibrate();
    ApiRequestManager.deleteProduct(productId).then((value) {
      SalesMenuScreen.refreshTab?.call(0);
    }).catchError((e) {
      Message.error(context).show("Connection failure. Check your internet and try again.");
    });
  }

  void deletePackage(BuildContext context, String packageId) {
    HapticFeedback.vibrate();
    ApiRequestManager.deletePackage(packageId).then((value) {
      SalesMenuScreen.refreshTab?.call(1);
    }).catchError((e) {
      Message.error(context).show("Connection failure. Check your internet and try again.");
    });
  }

  Future<void> editProduct(BuildContext context) async {
    HapticFeedback.selectionClick();
    GlobalKey<ProductCreationTabState> productEditTab = GlobalKey<ProductCreationTabState>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return ProductCreationTab(
          key: productEditTab,
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
              ProductData product = ProductData(
                id: widget.item.id,
                title: formElements()[StoreContentType.Product]![ProductFormElements.nameCont].text,
                description:
                    formElements()[StoreContentType.Product]![ProductFormElements.descCont].text,
                price: double.parse(
                    formElements()[StoreContentType.Product]![ProductFormElements.priceCont].text),
                remainingAmount: int.parse(
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
                  SalesMenuScreen.refreshTab?.call(0);
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

  Future<void> editPackage(BuildContext context) async {
    HapticFeedback.selectionClick();
    GlobalKey<PackageCreation1State> packageEditTab = GlobalKey<PackageCreation1State>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return PackageCreation1(
          key: packageEditTab,
          package: widget.item as PackageData,
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
                  SalesMenuScreen.refreshTab?.call(1);
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
        );
      },
    );
    return;
  }

  StoreContentType _getItemTypeOfCurrentItem() =>
      widget.item is ProductData ? StoreContentType.Product : StoreContentType.Package;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    final bool notInCounterMode = widget.onSelectedAmountChange == null;
    const Color red = MyConstants.red;
    final Color transparentRed = red.withOpacity(0.4);
    final Color splashColorOnHover = notInCounterMode ? red : Colors.transparent;
    final Color borderColorOnHover = notInCounterMode ? transparentRed : Colors.transparent;
    void options() => showOptions(context, _getItemTypeOfCurrentItem(), widget.item.id);
    return Stack(
      children: [
        InkWell(
          onTap: select,
          onLongPress: notInCounterMode ? options : null,
          splashColor: splashColorOnHover,
          focusColor: borderColorOnHover,
          highlightColor: borderColorOnHover,
          borderRadius: BorderRadius.circular(16),
          child: _card(width, notInCounterMode),
        ),
        if (widget.onSelected != null) _animatedSelectedIcon(),
      ],
    );
  }

  Card _card(double width, bool notInCounterMode) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 10,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                _imagePreview(width),
                _titleAndText(width),
                _priceOrAmount(notInCounterMode),
              ],
            ),
            _remainingAmount(),
          ],
        ),
      ),
    );
  }

  Widget _animatedSelectedIcon() {
    return Align(
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
    );
  }

  Widget _titleAndText(double width) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
      width: width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.75),
          ),
          Text(widget.item.description, overflow: TextOverflow.fade),
        ],
      ),
    );
  }

  Image _imagePreview(double width) {
    return Image.network(
      widget.item.imagePath!,
      height: 128,
      width: width * 0.2,
    );
  }

  Widget _priceOrAmount(bool notInCounterMode) {
    if (!notInCounterMode)
      return AmountSelector(
        onAmountChange: widget.onSelectedAmountChange!,
        startAmount: widget.startAmount,
      );
    else
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: Text(
          "💸\n${widget.item.getPrice}",
          style: const TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }

  Widget _remainingAmount() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          "${widget.item.getRemainingAmount()} ${widget.item is ProductData ? "remaining" : "products packed"}",
          style: TextStyle(
            color:
                widget.item.getRemainingAmount() != 0 ? Colors.grey.shade600 : Colors.red.shade800,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AmountSelector extends StatefulWidget {
  final Function(int newAmount) onAmountChange;
  final int startAmount;
  final bool forcePositive;
  const AmountSelector(
      {super.key, required this.onAmountChange, this.startAmount = 1, this.forcePositive = true});

  @override
  State<AmountSelector> createState() => _AmountSelectorState();
}

class _AmountSelectorState extends State<AmountSelector> {
  late int _selectedAmount;
  @override
  void initState() {
    super.initState();
    _selectedAmount = widget.startAmount;
  }

  set selectedAmount(int amount) {
    if (widget.forcePositive && amount >= 0) _selectedAmount = amount;
  }

  int get selectedAmount => _selectedAmount;

  void changeAmount(bool increment) {
    setState(() {
      increment ? selectedAmount++ : selectedAmount--;
    });
    try {
      widget.onAmountChange(selectedAmount);
    } on Exception {
      setState(() {
        increment ? selectedAmount-- : selectedAmount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: MyConstants.accentColor2),
            onPressed: () => changeAmount(true),
          ),
          Text(
            selectedAmount.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: MyConstants.accentColor2),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: MyConstants.accentColor2),
            onPressed: () => changeAmount(false),
          ),
        ],
      ),
    );
  }
}
