import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/models/store.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/register_screen/register.dart';
import 'package:pop_app/reusable_components/message.dart';

/// This screen has a lot of work to do.
/// First, for buyers, it fetches all stores.
/// Then, selected store needs to get assigned to both types of users.
class FourthRegisterScreen extends StatefulWidget {
  final RegisterScreen widget;
  const FourthRegisterScreen(this.widget, {super.key});

  @override
  State<FourthRegisterScreen> createState() => _FourthRegisterScreenState();
}

class _FourthRegisterScreenState extends State<FourthRegisterScreen> {
  bool areStoresFetched = false;
  bool storeFetchingFailed = false;
  Store? selectedStoreObject;
  List<Store> fetchedStores = List.empty(growable: true);

  void fetchStores() async {
    var stores = await ApiRequestManager.getAllStores(widget.widget.user);

    if ((stores?["DATA"] != null) && context.mounted) {
      for (var store in stores["DATA"]) {
        fetchedStores.add(Store(int.parse(store["Id_Trgovine"]), store["NazivTrgovine"],
            int.parse(store["StanjeRacuna"]), store["BrojZaposlenika"]));
      }

      setState(() {
        areStoresFetched = true;
      });
    } else {
      Message.error(context).show("An error occured while getting the list of available stores.");
      setState(() {
        storeFetchingFailed = true;
      });
    }
  }

  void _createStoreAndProceed() async {
    selectedStoreObject = await ApiRequestManager.createStore(
        widget.widget.user, widget.widget.storeNameController.text);
    _proceed();
  }

  void _assignStoreAndProceed(Store selectedStore) async {
    if (await ApiRequestManager.assignStore(widget.widget.user, selectedStore)) {
      selectedStoreObject = selectedStore;
    } else {
      selectedStoreObject = null;
    }
    _proceed();
  }

  void _proceed() {
    if (selectedStoreObject != null) {
      widget.widget.user.store = selectedStoreObject!;
      RegisterScreen.of(context)?.showNextRegisterScreen();
    } else {
      Message.error(context).show("Oh no!\n"
          "Something went wrong and the store could not be assigned to you.\n"
          "Try again later.");
    }
  }

  @override
  void initState() {
    if (widget.widget.user.getRole()?.roleName == "buyer") {
      fetchStores();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.widget.user.getRole()?.roleName == "seller"
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
                      _createStoreAndProceed();
                    }
                  },
                  type: FormSubmitButtonType.RED_FILL,
                )
              ],
            ),
          )
        : areStoresFetched
            ? CompanySelectionScreen((company) async {
                _assignStoreAndProceed(company);
              }, fetchedStores, showAppBar: false)
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
