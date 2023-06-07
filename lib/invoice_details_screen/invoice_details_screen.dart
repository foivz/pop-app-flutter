import 'package:flutter/material.dart';
import 'package:pop_app/models/invoice.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final Invoice invoice;
  const InvoiceDetailsScreen(this.invoice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(invoice.id.toString());
  }
}
