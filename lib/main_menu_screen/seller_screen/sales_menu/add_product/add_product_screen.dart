// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures, unused_field
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
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
  const CreateStoreContent({super.key});
  @override
  State<CreateStoreContent> createState() => _CreateStoreContentState();
}

class _CreateStoreContentState extends State<CreateStoreContent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _productFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _packageFormKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  // final ImagePicker _imagePicker = ImagePicker();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create store content")),
      body: tabs(),
    );
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
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: type == StoreContentType.Product ? _productFormKey : _packageFormKey,
            child: Column(children: _genFormInputs(type)),
          ),
        ),
      ),
    );
  }

  List<Widget> _genFormInputs(StoreContentType type) {
    return <Widget>[
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.nameLengthLimit)],
        inputLabel: _FormContent.nameHint(type),
        textEditingController: nameCont,
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      CustomTextFormField(
        inputFormatters: [LengthLimitingTextInputFormatter(_FormContent.descriptionLengthLimit)],
        inputLabel: _FormContent.descHint(type),
        textEditingController: descCont,
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            textFieldWidth: MyConstants.textFieldWidth * 0.6,
            inputLabel: _FormContent.priceHint(type),
            textEditingController: priceCont,
          ),
          const SizedBox(width: MyConstants.textFieldWidth * 0.05),
          CustomTextFormField(
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textFieldWidth: MyConstants.textFieldWidth * 0.35,
            inputLabel: _FormContent.quantityHint(),
            textEditingController: quantityCont,
          ),
        ],
      ),
      const SizedBox(height: MyConstants.formInputSpacer),
      const SizedBox(height: MyConstants.formInputSpacer),
      _buildImageInput(type),
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
              padding: const EdgeInsets.only(top: 10.0),
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
          ],
        );
      },
    );
  }
}

typedef OnPickImageCallback = void Function();
