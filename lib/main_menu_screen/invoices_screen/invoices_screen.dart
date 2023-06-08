import 'package:flutter/material.dart';
import 'package:pop_app/api_requests.dart';
import 'package:pop_app/main_menu_screen/invoices_screen/invoice_card.dart';
import 'package:pop_app/myconstants.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Finalized invoices"),
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, __) => const Divider(indent: 3, endIndent: 3, thickness: 0),
                  padding: const EdgeInsets.all(5),
                  itemBuilder: (context, index) {
                    return InvoiceCard(
                      index: index,
                      invoice: snapshot.data![index],
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No invoices",
                        style: TextStyle(
                          color: MyConstants.red,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "It's empty in here... 👀\nStart trading and then come back!",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      BackButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => MyConstants.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          future: ApiRequestManager.getAllInvoices(),
        ),
      ),
    );
  }
}
