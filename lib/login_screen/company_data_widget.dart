// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

class CompanyDataContainer extends StatefulWidget {
  final String companyName;
  final int employeeCount;

  const CompanyDataContainer({super.key, required this.companyName, required this.employeeCount});

  @override
  State<CompanyDataContainer> createState() => _CompanyDataContainerState();
}

class _CompanyDataContainerState extends State<CompanyDataContainer>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;
  late AnimationController _animCont;

  @override
  void initState() {
    super.initState();
    _animCont = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
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
        onTap: select,
        highlightColor: isSelected ? Colors.blue : null,
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
          width: MediaQuery.of(context).size.width,
          decoration: _border,
          child: Stack(children: [
            Text("${widget.companyName} - ${widget.employeeCount} employees"),
            Align(
              alignment: Alignment.centerRight,
              heightFactor: 0.8,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_animCont),
                child: ScaleTransition(
                  scale: Tween(begin: 0.0, end: 1.0).animate(_animCont),
                  child: Icon(
                    Icons.verified,
                    color: isSelected
                        ? MyConstants.red
                        : Colors.grey, // Change color based on isSelected value
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  final BoxDecoration _border = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: MyConstants.red, width: 3),
  );
}
