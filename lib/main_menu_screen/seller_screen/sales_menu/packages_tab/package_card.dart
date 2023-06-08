// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:pop_app/models/package_data.dart';
import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class PackageCard extends StatefulWidget {
  final int index;
  final PackageData packageData;
  final Function(bool isSelected, PackageData productData) onSelected;

  const PackageCard(
      {super.key, required this.index, required this.packageData, required this.onSelected});

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animCont;

  bool isSelected = false;

  void select() {
    setState(() {
      isSelected = !isSelected;
      widget.onSelected(isSelected, widget.packageData);
      if (isSelected)
        _animCont.forward();
      else
        _animCont.reverse();
    });
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
                  'https://cortex.foi.hr/pop/img/32/e2be5f700ee843c53a5fefdafe9e2f81c55c75fb151e76dd27572eb3a2378cd7.webp',
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
                        widget.packageData.title /*x${widget.packageData.count}*/,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(height: 1.75),
                      ),
                      Text(widget.packageData.description, overflow: TextOverflow.fade),
                    ],
                  ),
                ),
                Text(
                  widget.packageData.price.toString(),
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
