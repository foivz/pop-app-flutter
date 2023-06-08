import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pop_app/models/invoice.dart';
import 'package:pop_app/myconstants.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final Invoice invoice;
  const InvoiceDetailsScreen(this.invoice, {super.key});

  Widget showInvoiceAttribute(String key, String value) {
    return Row(
      children: [
        Text(
          "$key: ",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            color: MyConstants.accentColor2,
          ),
        )
      ],
    );
  }

  Widget getInvoiceItemsHeader(String name) {
    return Text(
      name,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invoice overview",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Invoice ${invoice.id}",
                style: TextStyle(fontSize: 30, color: Colors.grey.shade700),
              ),
              const Divider(),
              showInvoiceAttribute("Location", "FOI"),
              showInvoiceAttribute("Date", invoice.dateOfFinalization),
              showInvoiceAttribute("Seller", invoice.storeName),
              showInvoiceAttribute("Buyer", "${invoice.buyerFirstName} ${invoice.buyerLastName}"),
              showInvoiceAttribute("Discount percentage", "${invoice.discount}%"),
              showInvoiceAttribute("Price before discount", invoice.price),
              showInvoiceAttribute("You saved", invoice.discountAmount),
              const Divider(),
              Text(
                "TOTAL: ${invoice.finalPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: MyConstants.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const SizedBox(
                        height: 30,
                        width: 1000,
                      ),
                    ),
                  ),
                  Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: getInvoiceItemsHeader("Item")),
                          DataColumn(label: getInvoiceItemsHeader("Quantity")),
                          DataColumn(label: getInvoiceItemsHeader("Price")),
                          DataColumn(label: getInvoiceItemsHeader("Total")),
                        ],
                        rows: invoice.items
                            .map(
                              (item) => DataRow(cells: <DataCell>[
                                DataCell(Text(item.name)),
                                DataCell(Text(item.quantity)),
                                DataCell(Text(item.price)),
                                DataCell(Text(item.totalPrice)),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
