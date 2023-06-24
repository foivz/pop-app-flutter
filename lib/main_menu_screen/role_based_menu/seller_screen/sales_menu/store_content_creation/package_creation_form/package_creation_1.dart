// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/store_content_creation/package_creation_form/package_creation_tab.dart';
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/store_content_creation/product_creation_form/product_creation_tab.dart';
import 'package:pop_app/reusable_components/form_submit_button_widget.dart';
import 'package:pop_app/reusable_components/form_text_input_field.dart';
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/utils/api_requests.dart';
import 'package:pop_app/utils/myconstants.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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
  final PackageData? package;
  final String? submitButtonLabel;
  final void Function()? onSubmit;
  const PackageCreation1({
    super.key,
    this.package,
    this.submitButtonLabel,
    this.onSubmit,
  });
  @override
  State<PackageCreation1> createState() => PackageCreation1State();
}

enum PackageFormElements { formKey, nameCont, descCont, discountCont }

class PackageCreation1State extends State<PackageCreation1> with AutomaticKeepAliveClientMixin {
  final Map<PackageFormElements, dynamic> _package = {
    PackageFormElements.formKey: GlobalKey<FormState>(),
    PackageFormElements.nameCont: TextEditingController(),
    PackageFormElements.descCont: TextEditingController(),
    PackageFormElements.discountCont: TextEditingController(),
  };

  File? packageImage;

  Map<StoreContentType, Map<PackageFormElements, dynamic>> formElements() {
    return {StoreContentType.Package: _package};
  }

  @override
  void initState() {
    super.initState();
    if (widget.package != null) {
      PackageData package = widget.package!;
      _package[PackageFormElements.nameCont].text = package.title;
      _package[PackageFormElements.descCont].text = package.description;
      _package[PackageFormElements.discountCont].text = package.discount.toString();
      loadImage();
    }
  }

  @override
  void dispose() {
    deleteImage();
    super.dispose();
  }

  Future deleteImage() async {
    final Directory temp = await getTemporaryDirectory();
    try {
      return await File("${temp.path}/productImageNet.png").delete();
    } catch (e) {/**/}
  }

  void loadImage() async {
    PackageData package = widget.package!;
    http.Response response = await http.get(Uri.parse(package.imagePath!));
    final Directory temp = await getTemporaryDirectory();
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    File file = await File("${temp.path}/packageImageNet$timestamp.png").create();
    file.writeAsBytesSync(response.bodyBytes);
    packageImage = file;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _genForm();
  }

  Widget _genForm() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formElements()[StoreContentType.Package]![PackageFormElements.formKey],
            child: Column(children: _genFormInputs()),
          ),
        ),
      ),
    );
  }

  List<Widget> _genFormInputs() {
    Text? title;
    if (widget.submitButtonLabel != null)
      title = Text(
        "Edit package",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: MyConstants.red),
      );
    var titleWidget = Container(
      padding: const EdgeInsets.only(bottom: 16),
      child: title,
    );
    return <Widget>[
      titleWidget,
      FormTextInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.nameLengthLimit)],
        maxLength: _FormContent.nameLengthLimit,
        inputLabel: _FormContent.nameHint(),
        textEditingController:
            formElements()[StoreContentType.Package]![PackageFormElements.nameCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormTextInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.descriptionLengthLimit)],
        maxLength: _FormContent.descriptionLengthLimit,
        inputLabel: _FormContent.descHint(),
        textEditingController:
            formElements()[StoreContentType.Package]![PackageFormElements.descCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      _discountInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      _buildImageInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormSubmitButton(
        buttonText: widget.submitButtonLabel ?? "Next",
        onPressed: widget.onSubmit ??
            () {
              var form = (formElements()[StoreContentType.Package]![PackageFormElements.formKey]
                  as GlobalKey<FormState>);

              if (!form.currentState!.validate()) {
                Message.error(context).show("Not all fields are filled.");
                return;
              }

              PackageData packageData = PackageData(
                title: formElements()[StoreContentType.Package]![PackageFormElements.nameCont].text,
                description:
                    formElements()[StoreContentType.Package]![PackageFormElements.descCont].text,
                discount: double.parse(
                    formElements()[StoreContentType.Package]![PackageFormElements.discountCont]
                        .text),
                imageFile: packageImage,
                products: [],
              );

              if (packageData.title.contains("'") || packageData.description.contains("'")) {
                Message.error(context)
                    .show("Do not use ' character in your title and description!");
                return;
              }

              try {
                ApiRequestManager.addPackageToStore(
                  packageData,
                ).then((value) {
                  PackageCreationTab.of(context)!.showProductSelectionScreen();
                }).catchError((error) {
                  Message.error(context)
                      .show("Connection failure. Check your internet and try again.");
                });
              } catch (e) {
                Message.error(context).show("Not all fields are filled error.");
              }
            },
      ),
    ];
  }

  FormTextInputField _discountInput() {
    return FormTextInputField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        _MaxValueInputFormatter(100),
      ],
      inputLabel: _FormContent.discountHint(),
      textEditingController:
          formElements()[StoreContentType.Package]![PackageFormElements.discountCont],
    );
  }

  Future<void> _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => packageImage = File(pickedFile.path));
  }

  Future<void> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => packageImage = File(pickedFile.path));
  }

  Widget _buildImageInput() {
    if (packageImage != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyConstants.red, width: 3),
        ),
        child: InkWell(
          onTap: () => _showImagePicker(),
          child: Image.file(
            packageImage!,
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
              enabled: packageImage != null,
              tileColor: packageImage == null ? Colors.black.withOpacity(0.4) : null,
              onTap: () {
                setState(() => packageImage = null);
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
