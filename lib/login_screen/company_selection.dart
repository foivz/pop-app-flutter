// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/login_screen/company_data_container_widget.dart';

import 'package:flutter/material.dart';
import 'package:pop_app/role_selection/role_selection_screen.dart';
import 'package:pop_app/screentransitions.dart';

class CompanySelectionScreen extends StatefulWidget {
  final Function(String company) onCompanySelected;
  const CompanySelectionScreen(this.onCompanySelected, {super.key});

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
        appBar: AppBar(title: const Text("Company selection")),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedCompany == null) {
              if (!_lockSnackbar) {
                _lockSnackbar = true;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  dismissDirection: DismissDirection.down,
                  content: Text("You must select a company."),
                  duration: Duration(seconds: 1),
                ));
                Future.delayed(const Duration(seconds: 1), () => _lockSnackbar = false);
              }
            } else {
              var state = selectedCompany?.currentState;

              if (state != null) {
                widget.onCompanySelected((state as CompanyDataContainer).companyName);
              }
            }
          },
          child: const Icon(Icons.check),
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            List<Widget> companies = [];
            if (snapshot.hasData) {
              (snapshot.data as Map).forEach((key, value) {
                GlobalKey companyKey = GlobalKey();
                companies.add(CompanyDataContainer(
                  key: companyKey,
                  companyName: key,
                  employeeCount: value,
                  onTapCallback: () {
                    state(o) => (((o.key as GlobalKey).currentState) as CompanyDataContainerState);
                    companies.where((company) => state(company).isSelected).forEach((company) {
                      state(company).select();
                    });
                    (companyKey.currentState as CompanyDataContainerState).select();
                    selectedCompany = companyKey;
                  },
                ));
              });
              return Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(children: companies),
                  ),
                ),
              );
            } else
              return const Center(child: CircularProgressIndicator());
          },
          // TODO: define future to load data: "future: asyncFunc()" and remove initialData
          initialData: const {
            "Company1 d.o.o.": 2,
            "Company2 d.o.o.": 1,
            "Company3 d.o.o.": 3,
            "Company4 d.o.o.": 1
          },
        ),
      ),
    );
  }
}
