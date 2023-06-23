// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures, unused_field
import 'package:pop_app/main_menu_screen/role_based_menu/seller_screen/sales_menu/sales_menu.dart';
import 'package:pop_app/reusable_components/form_submit_button_widget.dart';
import 'package:pop_app/reusable_components/form_text_input_field.dart';
import 'package:pop_app/models/product_data.dart';
import 'package:pop_app/reusable_components/message.dart';
import 'package:pop_app/utils/api_requests.dart';
import 'package:pop_app/utils/myconstants.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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

class ProductCreationTab extends StatefulWidget {
  final ProductData? product;
  final String? submitButtonLabel;
  final void Function()? onSubmit;

  const ProductCreationTab({
    super.key,
    this.product,
    this.submitButtonLabel,
    this.onSubmit,
  });

  static ProductCreationTabState? of(BuildContext context) {
    try {
      return context.findAncestorStateOfType<ProductCreationTabState>();
    } catch (err) {
      return null;
    }
  }

  @override
  State<ProductCreationTab> createState() => ProductCreationTabState();
}

enum ProductFormElements {
  formKey,
  nameCont,
  descCont,
  priceCont,
  quantityCont,
  discountCont,
  image
}

class ProductCreationTabState extends State<ProductCreationTab>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final Map<ProductFormElements, dynamic> _product = {
    ProductFormElements.formKey: GlobalKey<FormState>(),
    ProductFormElements.nameCont: TextEditingController(),
    ProductFormElements.descCont: TextEditingController(),
    ProductFormElements.priceCont: TextEditingController(),
    ProductFormElements.quantityCont: TextEditingController(),
  };

  File? productImage;

  Map<StoreContentType, Map<ProductFormElements, dynamic>> formElements() {
    return {
      StoreContentType.Product: _product,
    };
  }

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      (_product[ProductFormElements.nameCont] as TextEditingController).text =
          widget.product!.title;
      (_product[ProductFormElements.descCont] as TextEditingController).text =
          widget.product!.description;
      (_product[ProductFormElements.priceCont] as TextEditingController).text =
          widget.product!.price.toString();
      (_product[ProductFormElements.quantityCont] as TextEditingController).text =
          widget.product!.remainingAmount.toString();
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
    http.Response response = await http.get(Uri.parse(widget.product!.imagePath!));
    final Directory temp = await getTemporaryDirectory();
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    File file = await File("${temp.path}/productImageNet$timestamp.png").create();
    file.writeAsBytesSync(response.bodyBytes);
    productImage = file;
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
            key: formElements()[StoreContentType.Product]![ProductFormElements.formKey],
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
        "Edit product",
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: MyConstants.red),
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
            formElements()[StoreContentType.Product]![ProductFormElements.nameCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormTextInputField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.descriptionLengthLimit)],
        maxLength: _FormContent.descriptionLengthLimit,
        inputLabel: _FormContent.descHint(),
        textEditingController:
            formElements()[StoreContentType.Product]![ProductFormElements.descCont],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      _priceQuantityInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      _buildImageInput(),
      const SizedBox(height: MyConstants.formInputSpacer),
      FormSubmitButton(
        buttonText: widget.submitButtonLabel ?? "Add to store",
        onPressed: widget.onSubmit ??
            () {
              var form = (formElements()[StoreContentType.Product]![ProductFormElements.formKey]
                  as GlobalKey<FormState>);
              if (!form.currentState!.validate()) {
                Message.error(context).show("Not all fields are filled.");
                return;
              }
              try {
                String productName =
                    formElements()[StoreContentType.Product]![ProductFormElements.nameCont].text;
                String productDescription =
                    formElements()[StoreContentType.Product]![ProductFormElements.descCont].text;
                double productPrice = double.parse(
                    formElements()[StoreContentType.Product]![ProductFormElements.priceCont].text);
                int productAmount = int.parse(
                    formElements()[StoreContentType.Product]![ProductFormElements.quantityCont]
                        .text);

                ProductData product = ProductData(
                  title: productName,
                  description: productDescription,
                  price: productPrice,
                  remainingAmount: productAmount,
                  imageFile: productImage,
                );

                if (product.title.contains("'") || product.description.contains("'")) {
                  Message.error(context)
                      .show("Do not use ' character in your title and description!");
                  return;
                }

                ApiRequestManager.addProductToStore(product).then((response) {
                  if (response.statusCode == 200) {
                    Message.info(context).show(
                      "Added $productName to store.",
                    );
                    SalesMenuScreen.refreshTab?.call(0);
                    Navigator.pop(context, true);
                  } else
                    Message.error(context).show(
                      "Failed to add $productName to store.",
                    );
                }).catchError((error) {
                  Message.error(context)
                      .show("Connection failure. Check your internet and try again.");
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
        FormTextInputField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
          textFieldWidth: MyConstants.textFieldWidth * 0.6,
          inputLabel: _FormContent.priceHint(),
          textEditingController:
              formElements()[StoreContentType.Product]![ProductFormElements.priceCont],
        ),
        const SizedBox(width: MyConstants.textFieldWidth * 0.05),
        FormTextInputField(
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textFieldWidth: MyConstants.textFieldWidth * 0.35,
          inputLabel: _FormContent.quantityHint(),
          textEditingController:
              formElements()[StoreContentType.Product]![ProductFormElements.quantityCont],
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
    if (pickedFile != null) setState(() => productImage = File(pickedFile.path));
  }

  Future<void> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: MyConstants.textFieldWidth,
      maxWidth: MyConstants.textFieldWidth,
    );
    if (pickedFile != null) setState(() => productImage = File(pickedFile.path));
  }

  Widget _buildImageInput() {
    if ((productImage) != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: MyConstants.red, width: 3),
        ),
        child: InkWell(
          onTap: () => _showImagePicker(),
          child: Image.file(
            (productImage)!,
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
              "Add a picture of your product",
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
              enabled: (productImage) != null,
              tileColor: (productImage) == null ? Colors.black.withOpacity(0.4) : null,
              onTap: () {
                setState(() => productImage = null);
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
