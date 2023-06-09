// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures, unused_field
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/package_creation_form/package_creation_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_list_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';

enum StoreContentType { Product, Package }

class _FormContent {
  static const int nameLengthLimit = 25;
  static String nameHint() => "Product name";
  static const int descriptionLengthLimit = 150;
  static String descHint() => "Product description";
  static String priceHint() => "Product price";
  static String quantityHint() => "Quantity";
  static Icon imagePlaceholder() {
    return const Icon(
      Icons.add_circle_outline,
      color: Colors.white,
      size: 64,
    );
  }
}

class CreateStoreContent extends StatefulWidget {
  final GlobalKey<SalesMenuScreenState> salesMenuKey;
  final User user;
  const CreateStoreContent({super.key, required this.salesMenuKey, required this.user});
  @override
  State<CreateStoreContent> createState() => _CreateStoreContentState();
}

enum _FormElements { formKey, nameCont, descCont, priceCont, quantityCont, discountCont, image }

class _CreateStoreContentState extends State<CreateStoreContent>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Map<_FormElements, dynamic> _product = {
    _FormElements.formKey: GlobalKey<FormState>(),
    _FormElements.nameCont: TextEditingController(),
    _FormElements.descCont: TextEditingController(),
    _FormElements.priceCont: TextEditingController(),
    _FormElements.quantityCont: TextEditingController(),
  };

  File? _imageProd, _imagePack;

  Map<StoreContentType, Map<_FormElements, dynamic>> formElements() {
    return {
      StoreContentType.Product: _product,
    };
  }

  final GlobalKey<ProductsTabState> _productListKey = GlobalKey<ProductsTabState>();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    packageCreationForm = PackageCreationTab(productListKey: _productListKey, user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(child: tabs());
  }

  late PackageCreationTab packageCreationForm;
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

  get productCreationForm => _genForm();
  Widget _genForm() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formElements()[StoreContentType.Product]![_FormElements.formKey],
            child: Column(children: _genFormInputs()),
          ),
        ),
      ),
    );
  }

  List<Widget> _genFormInputs() {
    return <Widget>[
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.nameLengthLimit)],
        maxLength: _FormContent.nameLengthLimit,
        inputLabel: _FormContent.nameHint(),
        textEditingController: formElements()[StoreContentType.Product]![_FormElements.nameCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.descriptionLengthLimit)],
        maxLength: _FormContent.descriptionLengthLimit,
        inputLabel: _FormContent.descHint(),
        textEditingController: formElements()[StoreContentType.Product]![_FormElements.descCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      _priceQuantityInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      _buildImageInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormSubmitButton(
        buttonText: "Add to store",
        onPressed: () {
          var form = (formElements()[StoreContentType.Product]![_FormElements.formKey]
              as GlobalKey<FormState>);
          form.currentState!.validate();
          try {
            ConstantProductData product = ConstantProductData(
              -1,
              title: formElements()[StoreContentType.Product]![_FormElements.nameCont].text,
              description: formElements()[StoreContentType.Product]![_FormElements.descCont].text,
              price: double.parse(
                  formElements()[StoreContentType.Product]![_FormElements.priceCont].text),
              amount: int.parse(
                  formElements()[StoreContentType.Product]![_FormElements.quantityCont].text),
              imageFile: _imageProd,
            );
            ApiRequestManager.addProductToStore(product).then((response) {
              if (response.statusCode == 200) {
                Message.info(context).show(
                  "Added ${formElements()[StoreContentType.Product]![_FormElements.nameCont].text} to store.",
                );
                Navigator.pop(context, true);
              } else
                Message.error(context).show(
                  "Failed to add ${formElements()[StoreContentType.Product]![_FormElements.nameCont].text} to store.",
                );
            }).catchError((error) {
              Message.error(context).show("Connection failure. Check your internet and try again.");
            });
          } catch (e) {
            Message.error(context).show("Not all fields are filled.");
          }
        },
      ),
    ];
  }

  Row _priceQuantityInput() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          textFieldWidth: MyConstants.textFieldWidth * 0.6,
          inputLabel: _FormContent.priceHint(),
          textEditingController: formElements()[StoreContentType.Product]![_FormElements.priceCont],
        ),
        const SizedBox(width: MyConstants.textFieldWidth * 0.05),
        CustomTextFormField(
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textFieldWidth: MyConstants.textFieldWidth * 0.35,
          inputLabel: _FormContent.quantityHint(),
          textEditingController:
              formElements()[StoreContentType.Product]![_FormElements.quantityCont],
        ),
      ],
    );
  }

  Future<void> _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => _imageProd = File(pickedFile.path));
  }

  Future<void> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => _imageProd = File(pickedFile.path));
  }

  Widget _buildImageInput() {
    if ((_imageProd) != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyConstants.red, width: 3),
        ),
        child: InkWell(
          onTap: () => _showImagePicker(),
          child: Image.file(
            (_imageProd)!,
            width: MyConstants.textFieldWidth,
            height: MyConstants.textFieldWidth,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container(
        width: MyConstants.textFieldWidth,
        height: MyConstants.textFieldWidth,
        color: MyConstants.red,
        child: InkWell(
          onTap: () => _showImagePicker(),
          child: _FormContent.imagePlaceholder(),
        ),
      );
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                "Add a picture of your product",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera, color: Colors.white),
              title: const Text('Take a photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                _getFromCamera();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Choose from gallery', style: TextStyle(color: Colors.white)),
              onTap: () {
                _getFromGallery();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.white),
              title: const Text('Clear photo', style: TextStyle(color: Colors.white)),
              enabled: (_imageProd) != null,
              tileColor: (_imageProd) == null ? Colors.black.withOpacity(0.4) : null,
              onTap: () {
                setState(() => _imageProd = null);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MaxValueInputFormatter extends TextInputFormatter {
  final double maxValue;

  _MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    } else {
      double inputValue = double.tryParse(newValue.text) ?? 0.0;
      if (inputValue <= maxValue) {
        return newValue;
      } else {
        // Return the old value if the input is greater than the max value
        return oldValue;
      }
    }
  }
}
