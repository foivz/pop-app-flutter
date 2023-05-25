// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pop_app/myconstants.dart';

enum FormSubmitButtonType { RED_FILL, RED_OUTLINE }

class FormSubmitButton extends StatefulWidget {
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
  State<FormSubmitButton> createState() => FormSubmitButtonState();
}

class FormSubmitButtonState extends State<FormSubmitButton> {
  bool enabled = true;

  void setEnabled(bool state) => setState(() => enabled = state);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _style(),
      onPressed: widget.onPressed,
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: _isRedFill() ? Colors.white : MyConstants.red,
          fontSize: widget.fontSize ?? Theme.of(context).textTheme.titleLarge!.fontSize,
        ),
      ),
    );
  }

  bool _isRedFill() => widget.type == FormSubmitButtonType.RED_FILL;

  ButtonStyle _style() {
    var size = MaterialStateProperty.all<Size>(Size(widget.width, widget.height));
    var acc = MaterialStateProperty.all<Color>(
        enabled ? MyConstants.accentColor : MyConstants.accentColor.withOpacity(0.3));
    if (_isRedFill())
      return ButtonStyle(
        fixedSize: size,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            enabled ? MyConstants.red : MyConstants.red.withOpacity(0.3)),
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
