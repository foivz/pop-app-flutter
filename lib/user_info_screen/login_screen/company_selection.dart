// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/user_info_screen/login_screen/company_data_container_widget.dart';
import 'package:pop_app/models/store.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/reusable_components/message.dart';

class CompanySelectionScreen extends StatefulWidget {
  final Function(Store company) onCompanySelected;
  final bool showAppBar;
  final List<Store> stores;
  const CompanySelectionScreen({
    super.key,
    required this.onCompanySelected,
    required this.stores,
    this.showAppBar = true,
  });

  @override
  State<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  GlobalKey? selectedCompany;
  bool _lockSnackbar = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.showAppBar ? AppBar(title: const Text("Company selection")) : null,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedCompany == null) {
              if (!_lockSnackbar) {
                _lockSnackbar = true;
                Message.error(context).show("You must select a company to continue.");
                Future.delayed(const Duration(seconds: 1), () => _lockSnackbar = false);
              }
            } else {
              var state = selectedCompany?.currentState;

              if (state != null) {
                widget.onCompanySelected((state as CompanyDataContainerState).widget.store);
              }
            }
          },
          child: const Icon(Icons.check),
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            List<Widget> companies = [];
            for (var store in (snapshot.data as List<Store>)) {
              GlobalKey companyKey = GlobalKey();
              companies.add(CompanyDataContainer(
                key: companyKey,
                store: store,
                onTapCallback: () {
                  state(o) => (((o.key as GlobalKey).currentState) as CompanyDataContainerState);
                  companies.where((company) => state(company).isSelected).forEach((company) {
                    state(company).select();
                  });
                  (companyKey.currentState as CompanyDataContainerState).select();
                  selectedCompany = companyKey;
                },
              ));
            }
            return Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Column(children: companies),
                ),
              ),
            );
          },
          initialData: widget.stores,
        ),
      ),
    );
  }
}
