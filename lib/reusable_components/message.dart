import 'package:flutter/material.dart';
import 'package:pop_app/utils/myconstants.dart';

class Message {
  late Color _color;
  Color _textColor = Colors.white;
  TextAlign _textAlign = TextAlign.start;
  late BuildContext _context;

  Message.info(BuildContext context) {
    _context = context;
    _textColor = Colors.white;
    _color = MyConstants.accentColor2;
    _textAlign = TextAlign.center;
  }

  Message.error(BuildContext context) {
    _context = context;
    _color = Colors.red;
  }

  void show(String displayText) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(
            displayText,
            textAlign: _textAlign,
            style: TextStyle(color: _textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
