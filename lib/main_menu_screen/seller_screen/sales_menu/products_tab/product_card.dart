// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/models/product_data.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final int index;
  final ProductData productdata;
  final Function(bool isSelected, ProductData productData)? onSelected;
  const ProductCard({super.key, required this.index, required this.productdata, this.onSelected});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animCont;

  bool isSelected = false;

  void select() {
    if (widget.onSelected != null) {
      setState(() {
        isSelected = !isSelected;
        widget.onSelected!.call(isSelected, widget.productdata);
        if (isSelected)
          _animCont.forward();
        else
          _animCont.reverse();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animCont = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        InkWell(
          onTap: select,
          splashColor: MyConstants.red,
          focusColor: MyConstants.red.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          highlightColor: MyConstants.red.withOpacity(0.4),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            elevation: 10,
            borderOnForeground: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Image.network(
                  widget.productdata.image,
                  height: 128,
                  width: width * 0.2,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                  width: width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productdata.title,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                      ),
                      Text(widget.productdata.description, overflow: TextOverflow.fade),
                    ],
                  ),
                ),
                Text(
                  "${widget.productdata.price}",
                  style: const TextStyle(color: MyConstants.accentColor),
                ),
              ]),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_animCont),
              child: ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(_animCont),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? MyConstants.red : Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    color: isSelected ? MyConstants.red : Colors.grey,
                    Icons.attach_money,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
