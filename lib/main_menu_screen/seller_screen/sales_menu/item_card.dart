// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/models/item.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  final int index;
  final Item item;
  final Function(bool isSelected, Item productData)? onSelected;

  /// Only works if 'onAmountChange' callback is set.
  final int amountSelected = 1;
  final Function()? onAmountChange;
  const ItemCard({
    super.key,
    required this.index,
    required this.item,
    this.onSelected,
    this.onAmountChange,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animCont;

  bool isSelected = false;

  void select() {
    if (widget.onSelected != null) {
      setState(() {
        isSelected = !isSelected;
        widget.onSelected!.call(isSelected, widget.item);
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
                  widget.item.image,
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
                        widget.item.title,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                      ),
                      Text(widget.item.description, overflow: TextOverflow.fade),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "💸\n${widget.item.getPrice()}",
                    style: const TextStyle(
                        color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
        if (widget.onAmountChange != null)
          AmountSelector((newAmount) {
            widget.item.setSelectedAmount(newAmount);
            widget.onAmountChange!.call();
          })
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AmountSelector extends StatefulWidget {
  final Function(int newAmount) onAmountChange;
  const AmountSelector(this.onAmountChange, {super.key});

  @override
  State<AmountSelector> createState() => _AmountSelectorState();
}

class _AmountSelectorState extends State<AmountSelector> {
  int selectedAmount = 1;

  void changeAmount(bool increment) {
    if (increment || selectedAmount != 1) {
      setState(() {
        increment ? selectedAmount++ : selectedAmount--;
      });
      try {
        widget.onAmountChange(selectedAmount);
      } on Exception {
        setState(() {
          selectedAmount--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => changeAmount(false),
            icon: const Icon(
              Icons.remove_circle_sharp,
              color: MyConstants.red,
            ),
            iconSize: 35,
          ),
          Text(
            selectedAmount.toString(),
            style: TextStyle(
              fontSize: 25,
              color: Colors.grey.shade800,
            ),
          ),
          IconButton(
            onPressed: () => changeAmount(true),
            icon: const Icon(
              Icons.add_circle_outlined,
              color: MyConstants.red,
            ),
            iconSize: 35,
          ),
        ],
      ),
    );
  }
}
