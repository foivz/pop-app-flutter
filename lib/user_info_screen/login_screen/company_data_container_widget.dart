// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pop_app/models/store.dart';
import 'package:pop_app/utils/myconstants.dart';

class CompanyDataContainer extends StatefulWidget {
  final Store store;
  final void Function() onTapCallback;

  const CompanyDataContainer({
    super.key,
    required this.store,
    required this.onTapCallback,
  });

  @override
  State<CompanyDataContainer> createState() => CompanyDataContainerState();
}

class CompanyDataContainerState extends State<CompanyDataContainer>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;
  late AnimationController _animCont;

  @override
  void initState() {
    super.initState();
    _animCont = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  void select() {
    setState(() {
      isSelected = !isSelected;
      if (isSelected)
        _animCont.forward();
      else
        _animCont.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: InkWell(
        onTap: () {
          widget.onTapCallback.call();
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          width: MediaQuery.of(context).size.width,
          decoration: _border(),
          child: Stack(children: [
            Text("${widget.store.storeName} - ${widget.store.employeeCount} employees"),
            Align(
              alignment: Alignment.centerRight,
              heightFactor: 0.8,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_animCont),
                child: ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0).animate(_animCont),
                  child: Icon(
                    color: isSelected
                        ? MyConstants.accentColor
                        : Colors.grey, // Change color based on isSelected value
                    Icons.verified,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  BoxDecoration _border() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: isSelected ? MyConstants.accentColor : MyConstants.red,
        width: 3,
      ),
    );
  }
}
