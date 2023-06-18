import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/exceptions/printable_exception.dart';
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

  void _createStoreAndProceed(String storeName) async {
    try {
      selectedStoreObject = await ApiRequestManager.createStore(storeName);
      onStoreFetched();
    } on Exception catch (e) {
      Message.error(context).show(e.message);
    }
  }

  void _assignStoreAndProceed(Store selectedStore) async {
    if (await ApiRequestManager.assignStore(selectedStore)) {
      selectedStoreObject = selectedStore;
    } else {
      selectedStoreObject = null;
    }
    onStoreFetched();
    setState(() {});
  }

  Future fetchStores() async {
    var stores = await ApiRequestManager.getAllStores();
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

  Widget storeSelection(GlobalKey<FormState> formKey, TextEditingController storeNameController) {
    return User.loggedIn.role?.roleName == "seller"
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
                      _createStoreAndProceed(storeNameController.text);
                    }
                  },
                )
              ],
            ),
          )
        : CompanySelectionScreen(
            onCompanySelected: (company) async => _assignStoreAndProceed(company),
            stores: fetchedStores,
            showAppBar: false,
          );
  }
}
