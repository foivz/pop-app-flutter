import 'dart:math';

import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/package_creation_form/package_creation_tab.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/add_product/add_product_screen.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/main_menu_screen/seller_screen/sales_menu/packages_tab/package_data.dart';
import 'package:pop_app/myconstants.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:pop_app/reusable_components/message.dart';

class _FormContent {
  static const int nameLengthLimit = 25;
  static String nameHint() => "Package name";
  static const int descriptionLengthLimit = 150;
  static String descHint() => "Package description";
  static String discountHint() => "Package discount in %";
  static Icon imagePlaceholder() {
    return const Icon(
      Icons.add_circle_outline,
      color: Colors.white,
      size: 64,
    );
  }
}

class PackageCreation1 extends StatefulWidget {
  const PackageCreation1({super.key});
  @override
  State<PackageCreation1> createState() => _PackageCreation1State();
}

enum _FormElements { formKey, nameCont, descCont, discountCont }

class _PackageCreation1State extends State<PackageCreation1> with AutomaticKeepAliveClientMixin {
  final Map<_FormElements, dynamic> _package = {
    _FormElements.formKey: GlobalKey<FormState>(),
    _FormElements.nameCont: TextEditingController(),
    _FormElements.descCont: TextEditingController(),
    _FormElements.discountCont: TextEditingController(),
  };

  File? _imagePack;

  Map<StoreContentType, Map<_FormElements, dynamic>> formElements() {
    return {StoreContentType.Package: _package};
  }

  _mockPackFormData() {
    const StoreContentType pack = StoreContentType.Package;
    formElements()[pack]![_FormElements.nameCont].text = "Mock name ${Random().nextInt(100)}";
    formElements()[pack]![_FormElements.descCont].text = "Mock desc ${Random().nextInt(10000)}";
    formElements()[pack]![_FormElements.discountCont].text =
        "${(Random().nextDouble() * 100).round() + Random().nextInt(99) / 100}";
  }

  @override
  void initState() {
    super.initState();
    _mockPackFormData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Form(
        key: formElements()[StoreContentType.Package]![_FormElements.formKey],
        child: Column(children: _genFormInputs()),
      ),
    );
  }

  List<Widget> _genFormInputs() {
    return <Widget>[
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.nameLengthLimit)],
        maxLength: _FormContent.nameLengthLimit,
        inputLabel: _FormContent.nameHint(),
        textEditingController: formElements()[StoreContentType.Package]![_FormElements.nameCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.descriptionLengthLimit)],
        maxLength: _FormContent.descriptionLengthLimit,
        inputLabel: _FormContent.descHint(),
        textEditingController: formElements()[StoreContentType.Package]![_FormElements.descCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      _discountInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      _buildImageInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormSubmitButton(
        buttonText: "Next",
        onPressed: () {
          var form = (formElements()[StoreContentType.Package]![_FormElements.formKey]
              as GlobalKey<FormState>);
          form.currentState!.validate();
          try {
            ApiRequestManager.addPackageToStore(
              PackageData(
                title: formElements()[StoreContentType.Package]![_FormElements.nameCont].text,
                description: formElements()[StoreContentType.Package]![_FormElements.descCont].text,
                discount: double.parse(
                    formElements()[StoreContentType.Package]![_FormElements.discountCont].text),
                imageFile: _imagePack,
                products: [],
              ),
            ).then((value) {
              PackageCreationTab.of(context)!.showProductSelectionScreen();
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

  CustomTextFormField _discountInput() {
    return CustomTextFormField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        _MaxValueInputFormatter(100),
      ],
      inputLabel: _FormContent.discountHint(),
      textEditingController: formElements()[StoreContentType.Package]![_FormElements.discountCont],
    );
  }

  Future<void> _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => _imagePack = File(pickedFile.path));
  }

  Future<void> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => _imagePack = File(pickedFile.path));
  }

  Widget _buildImageInput() {
    if (_imagePack != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyConstants.red, width: 3),
        ),
        child: InkWell(
          onTap: () => _showImagePicker(),
          child: Image.file(
            _imagePack!,
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
            Text(
              "Add a picture of your package",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
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
              enabled: _imagePack != null,
              tileColor: _imagePack == null ? Colors.black.withOpacity(0.4) : null,
              onTap: () {
                setState(() => _imagePack = null);
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
