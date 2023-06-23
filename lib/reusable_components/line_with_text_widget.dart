import 'package:flutter/material.dart';
import 'package:pop_app/utils/myconstants.dart';

class LineWithText extends StatelessWidget {
  final String lineText;
  final double width, height, fontSize;
  final Color lineColor, textColor, textBackgroundColor;
  const LineWithText({
    super.key,
    required this.lineText,
    this.width = MyConstants.textFieldWidth / 3,
    this.height = 1,
    this.fontSize = 20,
    this.lineColor = Colors.black,
    this.textColor = Colors.black,
    this.textBackgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: lineColor,
          ),
        ),
        Center(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Text(
              lineText,
              style: TextStyle(
                backgroundColor: textBackgroundColor,
                fontSize: fontSize,
                color: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
