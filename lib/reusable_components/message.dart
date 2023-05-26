import 'package:flutter/material.dart';

class Message {
  late Color _color;
  late BuildContext _context;

  Message.info(BuildContext context) {
    _context = context;
    _color = Colors.blue.shade50;
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
            height: 90,
            decoration: BoxDecoration(
                color: _color,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Text(displayText)),
      ),
    );
  }
}
