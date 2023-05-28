import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/models/store.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';
import 'package:pop_app/reusable_components/message.dart';

abstract class StoreFetcher<T extends StatefulWidget> extends State<T> {
  void onStoreFetched();
}

mixin StoreFetcherMixin<T extends StatefulWidget> on StoreFetcher<T> {
  bool areStoresFetched = false;
  bool storeFetchingFailed = false;
  Store? selectedStoreObject;
  List<Store> fetchedStores = List.empty(growable: true);

  void _createStoreAndProceed(User user, String storeName) async {
    selectedStoreObject = await ApiRequestManager.createStore(user, storeName);
    onStoreFetched();
  }

  void _assignStoreAndProceed(User user, Store selectedStore) async {
    if (await ApiRequestManager.assignStore(user, selectedStore)) {
      selectedStoreObject = selectedStore;
    } else {
      selectedStoreObject = null;
    }
    onStoreFetched();
  }

  void fetchStores(User user) async {
    var stores = await ApiRequestManager.getAllStores(user);

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

  Widget storeSelection(
      User user, GlobalKey<FormState> formKey, TextEditingController storeNameController) {
    return user.getRole()?.roleName == "seller"
        ? Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextFormField(
                  inputLabel: "Store name",
                  textEditingController: storeNameController,
                  autoFocus: true,
                ),
                const SizedBox(height: MyConstants.formInputSpacer * 1.5),
                FormSubmitButton(
                  buttonText: 'Next',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _createStoreAndProceed(user, storeNameController.text);
                    }
                  },
                  type: FormSubmitButtonType.RED_FILL,
                )
              ],
            ),
          )
        : areStoresFetched
            ? CompanySelectionScreen((company) async {
                _assignStoreAndProceed(user, company);
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
