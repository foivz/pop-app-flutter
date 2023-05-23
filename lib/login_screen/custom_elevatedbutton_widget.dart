// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

enum FormSubmitButtonType { RED_FILL, RED_OUTLINE }

class FormSubmitButton extends StatelessWidget {
  final FormSubmitButtonType type;
  final double width, height;
  final double? fontSize;
  final String buttonText;
  final void Function() onPressed;

  const FormSubmitButton({
    super.key,
    this.type = FormSubmitButtonType.RED_FILL,
    this.width = MyConstants.textFieldWidth,
    this.height = MyConstants.submitButtonHeight,
    this.fontSize,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _style(),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          color: _isRedFill() ? Colors.white : MyConstants.red,
          fontSize: fontSize ?? Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
      ),
    );
  }

  bool _isRedFill() => type == FormSubmitButtonType.RED_FILL;

  ButtonStyle _style() {
    var size = MaterialStateProperty.all<Size>(Size(width, height));
    var acc = MaterialStateProperty.all<Color>(MyConstants.accentColor);
    if (_isRedFill())
      return ButtonStyle(
        fixedSize: size,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(MyConstants.red),
        overlayColor: acc,
      );
    else
      return ButtonStyle(
        fixedSize: size,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: MyConstants.red, width: 3),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: acc,
      );
  }
}
