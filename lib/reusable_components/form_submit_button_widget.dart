// ignore_for_file: curly_braces_in_flow_control_structures, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pop_app/utils/myconstants.dart';

enum FormSubmitButtonStyle { FILL, OUTLINE }

class FormSubmitButton extends StatefulWidget {
  final FormSubmitButtonStyle type;
  final Color color;
  final Color highlightColor;
  final double width, height;
  final double? fontSize;
  final String buttonText;
  final Widget? leading;
  final MainAxisAlignment mainAxisAlignment;
  final void Function() onPressed;

  const FormSubmitButton({
    super.key,
    this.type = FormSubmitButtonStyle.FILL,
    this.color = MyConstants.red,
    this.highlightColor = MyConstants.accentColor,
    this.width = MyConstants.textFieldWidth,
    this.height = MyConstants.submitButtonHeight,
    this.leading,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.fontSize,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  State<FormSubmitButton> createState() => FormSubmitButtonState();
}

class FormSubmitButtonState extends State<FormSubmitButton> {
  bool enabled = true;
  bool loading = false;

  void setEnabled(bool state) => setState(() => enabled = state);
  void setLoading(bool state) {
    setState(() {
      loading = state;
      enabled = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double squareSize = widget.height > widget.width ? widget.width - 20 : widget.height - 20;
    return ElevatedButton(
      style: _style(),
      onPressed: widget.onPressed,
      child: !loading
          ? Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              children: [
                if (widget.leading != null) widget.leading!,
                Text(
                  widget.buttonText,
                  style: TextStyle(
                    color: _isFill() ? Colors.white : widget.color,
                    fontSize: widget.fontSize ?? Theme.of(context).textTheme.titleLarge!.fontSize,
                  ),
                ),
              ],
            )
          : const CircularProgressIndicator(color: Colors.white),
    );
  }

  bool _isFill() => widget.type == FormSubmitButtonStyle.FILL;

  ButtonStyle _style() {
    var size = MaterialStateProperty.all<Size>(Size(widget.width, widget.height));
    var acc = MaterialStateProperty.all<Color>(
      enabled ? widget.highlightColor : widget.highlightColor.withOpacity(0.3),
    );
    if (_isFill())
      return ButtonStyle(
        fixedSize: size,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          enabled ? widget.color : widget.color.withOpacity(0.3),
        ),
        overlayColor: acc,
      );
    else
      return ButtonStyle(
        fixedSize: size,
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: widget.color, width: 3),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        overlayColor: acc,
      );
  }
}
