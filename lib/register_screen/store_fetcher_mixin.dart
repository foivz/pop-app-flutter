import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/login_screen/company_selection.dart';
import 'package:pop_app/login_screen/custom_elevatedbutton_widget.dart';
import 'package:pop_app/login_screen/custom_textformfield_widget.dart';
import 'package:pop_app/models/store.dart';
import 'package:pop_app/models/user.dart';
import 'package:pop_app/myconstants.dart';

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
    setState(() {});
  }

  Future fetchStores(User user) async {
    var stores = await ApiRequestManager.getAllStores(user);
    setState(() {
      if ((stores?["DATA"] != null)) {
        fetchedStores.clear();
        for (var store in stores["DATA"]) {
          fetchedStores.add(Store(int.parse(store["Id_Trgovine"]), store["NazivTrgovine"],
              int.parse(store["StanjeRacuna"]), store["BrojZaposlenika"]));
        }
      }
      areStoresFetched = true;
    });
    return stores;
  }

  Widget storeSelection(
      User user, GlobalKey<FormState> formKey, TextEditingController storeNameController) {
    return user.role?.roleName == "seller"
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
                )
              ],
            ),
          )
        : CompanySelectionScreen(
            onCompanySelected: (company) async => _assignStoreAndProceed(user, company),
            stores: fetchedStores,
            showAppBar: false,
          );
  }
}
