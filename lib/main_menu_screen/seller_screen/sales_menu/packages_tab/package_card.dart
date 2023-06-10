// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/package_creation_form/package_creation_1.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_store_content/product_creation_form/product_creation_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PackageCard extends StatefulWidget {
  final int index;
  final PackageData package;

  final GlobalKey<SalesMenuScreenState> salesMenuKey;
  final User user;

  const PackageCard({
    super.key,
    required this.index,
    required this.package,
    required this.salesMenuKey,
    required this.user,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard>
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
                "Package options",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_square, color: Colors.white),
              title: const Text('Edit package', style: TextStyle(color: Colors.white)),
              onTap: edit,
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.white),
              title: const Text('Delete package', style: TextStyle(color: Colors.white)),
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
    ApiRequestManager.deletePackage(widget.package.id!).then((value) {
      SalesMenuScreen.of(context)!.loadTabContents();
      SalesMenuScreen.of(context)!.tabController.index = 1;
    }).catchError((e) {
      Message.error(context).show("Connection failure. Check your internet and try again.");
    });
  }

  Future<void> edit() async {
    HapticFeedback.selectionClick();
    GlobalKey<PackageCreation1State> packageEditTab = GlobalKey<PackageCreation1State>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return PackageCreation1(
          key: packageEditTab,
          package: widget.package,
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
                id: widget.package.id,
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
                  widget.package.imagePath!,
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
                        widget.package.title /*x${widget.packageData.count}*/,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                      ),
                      Text(widget.package.description, overflow: TextOverflow.fade),
                    ],
                  ),
                ),
                Text(
                  widget.package.price.toString(),
                  style: const TextStyle(color: MyConstants.accentColor),
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
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
