import 'package:pop_app/myconstants.dart';

import 'package:flutter/material.dart';

class RoleSelectWidget extends StatefulWidget {
  const RoleSelectWidget({super.key});

  @override
  State<RoleSelectWidget> createState() => RoleSelectWidgetState();
}

class RoleSelectWidgetState extends State<RoleSelectWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animCont;
  String selectedOption = 'buyer';

  @override
  void initState() {
    super.initState();
    _animCont = AnimationController(vsync: this, duration: Duration.zero)..forward();
  }

  @override
  void dispose() {
    _animCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double size = screenSize.width > screenSize.height ? screenSize.height : screenSize.width;
    size /= 2;
    size *= 0.8;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _option("Buyer", size, radioAlignment: Alignment.centerRight),
        _option("Seller", size, radioAlignment: Alignment.centerLeft),
      ],
    );
  }

  Widget _option(String option, double size, {Alignment radioAlignment = Alignment.center}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _label(option),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => setState(() => selectedOption = option.toLowerCase()),
          child: _img(option.toLowerCase(), size),
        ),
        _bigRadio(option, size, alignment: radioAlignment),
      ],
    );
  }

  Text _label(String labelText) {
    return Text(
      labelText,
      style: TextStyle(
        color: selectedOption == labelText.toLowerCase() ? MyConstants.red : null,
        fontSize: MyConstants.submitButtonHeight / 1.5,
      ),
    );
  }

  Image _img(String value, double size) {
    return Image.asset(
      'assets/options/${value}s.png',
      width: size,
      height: size,
      colorBlendMode: selectedOption == value ? BlendMode.multiply : BlendMode.dstATop,
      color: Colors.white.withOpacity(0.5),
    );
  }

  SizedBox _bigRadio(String option, double size, {Alignment alignment = Alignment.center}) {
    return SizedBox(
      width: size,
      child: Align(
        alignment: alignment,
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 3.0).animate(_animCont),
          child: Radio(
            value: option.toLowerCase(),
            activeColor: MyConstants.red,
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value ?? '';
              });
            },
          ),
        ),
      ),
    );
  }
}
