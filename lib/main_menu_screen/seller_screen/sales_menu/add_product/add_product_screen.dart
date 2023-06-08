// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures, unused_field
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/products_tab/product_data.dart';
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
import 'dart:math';
import 'dart:io';

enum StoreContentType { Product, Package }

class _FormContent {
  static const int nameLengthLimit = 25;
  static String nameHint(StoreContentType type) => "${type.name} name";
  static const int descriptionLengthLimit = 150;
  static String descHint(StoreContentType type) => "${type.name} description";
  static String priceHint(StoreContentType type) => "${type.name} price";
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

enum _FormElements { formKey, nameCont, descCont, priceCont, quantityCont }

class _CreateStoreContentState extends State<CreateStoreContent>
    with SingleTickerProviderStateMixin, RouteAware {
  final Map<_FormElements, dynamic> _product = {
    _FormElements.formKey: GlobalKey<FormState>,
    _FormElements.nameCont: TextEditingController(),
    _FormElements.descCont: TextEditingController(),
    _FormElements.priceCont: TextEditingController(),
    _FormElements.quantityCont: TextEditingController(),
  };

  final Map<_FormElements, dynamic> _package = {
    _FormElements.formKey: GlobalKey<FormState>,
    _FormElements.nameCont: TextEditingController(),
    _FormElements.descCont: TextEditingController(),
    _FormElements.priceCont: TextEditingController(),
    _FormElements.quantityCont: TextEditingController(),
  };

  Map<StoreContentType, Map<_FormElements, dynamic>> formElements() {
    return {
      StoreContentType.Product: _product,
      StoreContentType.Package: _package,
    };
  }

  final StoreContentType prod = StoreContentType.Product;
  final StoreContentType pack = StoreContentType.Package;

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    formElements()[prod]![_FormElements.nameCont].text = "Mock name ${Random().nextInt(100)}";
    formElements()[prod]![_FormElements.descCont].text = "Mock desc ${Random().nextInt(10000)}";
    formElements()[prod]![_FormElements.priceCont].text =
        "${(Random().nextDouble() * 100).round() + Random().nextInt(99) / 100}";
    formElements()[prod]![_FormElements.quantityCont].text = "${(Random().nextInt(10))}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: tabs());
  }

  Widget tabs() {
    return Column(children: [
      TabBar(
        padding: EdgeInsets.zero,
        controller: _tabController,
        tabs: const <Tab>[Tab(text: "Add product"), Tab(text: "Create package")],
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [_genForm(StoreContentType.Product), _genForm(StoreContentType.Package)],
        ),
      ),
    ]);
  }

  Widget _genForm(StoreContentType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: formElements()[type]!["formKey"],
              child: Column(children: _genFormInputs(type)),
            ),
          ),
        ),
      ),
    );
  }

  bool _isProd(StoreContentType type) => type == StoreContentType.Product;

  List<Widget> _genFormInputs(StoreContentType type) {
    return <Widget>[
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.nameLengthLimit)],
        maxLength: _FormContent.nameLengthLimit,
        inputLabel: _FormContent.nameHint(type),
        textEditingController: formElements()[type]![_FormElements.nameCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.descriptionLengthLimit)],
        maxLength: _FormContent.descriptionLengthLimit,
        inputLabel: _FormContent.descHint(type),
        textEditingController: formElements()[type]![_FormElements.descCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            textFieldWidth: MyConstants.textFieldWidth * 0.6,
            inputLabel: _FormContent.priceHint(type),
            textEditingController: formElements()[type]![_FormElements.priceCont],
          ),
          const SizedBox(width: MyConstants.textFieldWidth * 0.05),
          CustomTextFormField(
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textFieldWidth: MyConstants.textFieldWidth * 0.35,
            inputLabel: _FormContent.quantityHint(),
            textEditingController: formElements()[type]![_FormElements.quantityCont],
          ),
        ],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      _buildImageInput(type),
      const SizedBox(height: MyConstants.formInputSpacer),
      if (_isProd(type))
        FormSubmitButton(
          buttonText: "Add to store",
          onPressed: () {
            ProductData product = ProductData(
              title: formElements()[type]![_FormElements.nameCont].text,
              description: formElements()[type]![_FormElements.descCont].text,
              price: double.parse(formElements()[type]![_FormElements.priceCont].text),
              amount: int.parse(formElements()[type]![_FormElements.quantityCont].text),
              imageFile: _imageFile,
            );
            ApiRequestManager.addProductToStore(product).then((response) {
              if (response.statusCode == 200) {
                Message.info(context).show(
                  "Added ${formElements()[type]![_FormElements.nameCont].text} to store.",
                );
                Navigator.pop(context, true);
              } else
                Message.error(context).show(
                  "Failed to add ${formElements()[type]![_FormElements.nameCont].text} to store.",
                );
            });
          },
        ),
      if (type == StoreContentType.Package)
        FormSubmitButton(
          buttonText: "Next",
          onPressed: () {},
        ),
    ];
  }

  File? _imageFile;

  Future<void> _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Widget _buildImageInput(StoreContentType type) {
    if (_imageFile != null) {
      return InkWell(
        onTap: () => _showImagePicker(type),
        child: Image.file(
          _imageFile!,
          width: MyConstants.textFieldWidth,
          height: MyConstants.textFieldWidth,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        width: MyConstants.textFieldWidth,
        height: MyConstants.textFieldWidth,
        color: Colors.red,
        child: InkWell(
          onTap: () => _showImagePicker(type),
          child: _FormContent.imagePlaceholder(),
        ),
      );
    }
  }

  void _showImagePicker(StoreContentType type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Text(
                "Add a picture for your ${type.name.toLowerCase()}",
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
              enabled: _imageFile != null,
              tileColor: _imageFile == null ? Colors.black.withOpacity(0.4) : null,
              onTap: () {
                setState(() => _imageFile = null);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
