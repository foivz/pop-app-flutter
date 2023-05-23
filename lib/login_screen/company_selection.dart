// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pop_app/login_screen/company_data_widget.dart';

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
              if (snapshot.hasData)
                (snapshot.data as Map).forEach((key, value) {
                  companies.add(CompanyDataContainer(companyName: key, employeeCount: value));
                });
              return Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Column(children: companies),
                  ),
                ),
              );
            },
            initialData: const {
              'Comp1 d.o.o.': 3,
              'Comp2 d.o.o.': 1,
              'Comp3 d.o.o.': 3,
              'Comp4 d.o.o.': 0,
              'Comp5 d.o.o.': 2,
              'Comp6 d.o.o.': 5,
              'Comp7 d.o.o.': 2,
              'Comp8 d.o.o.': 1,
              'Comp9 d.o.o.': 1,
              'Comp10 d.o.o.': 4,
            }),
      ),
    );
  }
}
