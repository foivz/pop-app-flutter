import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/reusable_components/message.dart';

class FourthRegisterScreen extends StatefulWidget {
  final RegisterScreen widget;
  const FourthRegisterScreen(this.widget, {super.key});

  @override
  State<FourthRegisterScreen> createState() => _FourthRegisterScreenState();
}

class _FourthRegisterScreenState extends State<FourthRegisterScreen> {
  bool areStoresFetched = false;
  bool storeFetchingFailed = false;
  Map<int, String>? fetchedStores = null;

  void fetchStores() async {
    var stores = await ApiRequestManager.getAllStores(widget.widget.user);

    if ((stores?["DATA"] != null) && context.mounted) {
      Map<int, String> storesMap = Map();

      for (var store in stores["DATA"]) {
        Map<int, String> currentEntry = {int.parse(store["Id_Trgovine"]): store["NazivTrgovine"]};
        storesMap.addAll(currentEntry);
      }

      fetchedStores = storesMap;
      setState(() {
        areStoresFetched = true;
      });
    } else {
      Message.error(context).show("An error occured while getting the list of available stores.");
      storeFetchingFailed = true;
    }
  }

  @override
  void initState() {
    if (widget.widget.user.role == "buyer") {
      fetchStores();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.widget.user.role == "seller"
        ? Form(
            key: widget.widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  inputLabel: "Store name",
                  textEditingController: widget.widget.storeNameController,
                  autoFocus: true,
                ),
                const SizedBox(height: MyConstants.formInputSpacer * 1.5),
                FormSubmitButton(
                  buttonText: 'Next',
                  onPressed: () {
                    if (widget.widget.formKey.currentState!.validate()) {
                      widget.widget.user.storeName = widget.widget.storeNameController.text;
                      RegisterScreen.of(context)?.showNextRegisterScreen();
                    }
                  },
                  type: FormSubmitButtonType.RED_FILL,
                )
              ],
            ),
          )
        : areStoresFetched
            ? CompanySelectionScreen((company) async {
                widget.widget.user.storeName = widget.widget.storeNameController.text;
                RegisterScreen.of(context)?.showNextRegisterScreen();
              }, fetchedStores!, showAppBar: false)
            : !storeFetchingFailed
                ? const Center(child: CircularProgressIndicator())
                : const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Whoopsy! You weren't able to read the list of stores. Try to log in and finish the registration from there.",
                        style: TextStyle(
                            color: MyConstants.red, fontSize: 16, fontFamily: "RobotoMono-Regular"),
                      ),
                    ),
                  );
  }
}
