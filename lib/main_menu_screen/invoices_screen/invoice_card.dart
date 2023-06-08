// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/invoice_details_screen/invoice_details_screen.dart';
import 'package:pop_app/models/invoice.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class InvoiceCard extends StatefulWidget {
  final int index;
  final Invoice invoice;

  const InvoiceCard({super.key, required this.index, required this.invoice});

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        InkWell(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => InvoiceDetailsScreen(widget.invoice)),
            )
          },
          splashColor: MyConstants.red,
          focusColor: MyConstants.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          highlightColor: MyConstants.red.withOpacity(0.4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              border: Border.all(
                color: MyConstants.red,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                )
              ],
              borderRadius: const BorderRadius.all(
                Radius.elliptical(10, 10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Invoice: ${widget.invoice.id}",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                      ),
                      Text(
                        "${widget.invoice.finalPrice} HRK",
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${widget.invoice.dateOfFinalization.toString()} | Finalized",
                  style: const TextStyle(color: MyConstants.accentColor2),
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
