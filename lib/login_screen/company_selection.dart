// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/company_data_container_widget.dart';

class CompanySelectionScreen extends StatefulWidget {
  const CompanySelectionScreen({super.key});

  @override
  State<CompanySelectionScreen> createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Company selection")),
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
                    companies
                        .where((element) =>
                            ((element.key as GlobalKey).currentState as CompanyDataContainerState)
                                .isSelected)
                        .forEach((element) =>
                            (((element.key as GlobalKey).currentState) as CompanyDataContainerState)
                                .select());
                    (companyKey.currentState as CompanyDataContainerState).select();
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
