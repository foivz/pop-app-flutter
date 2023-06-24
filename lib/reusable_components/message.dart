import 'package:pop_app/utils/myconstants.dart';
import 'package:flutter/material.dart';

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

  Future<void> clear() async {
    _animCont!.reverse();
    await Future.delayed(_animReverseDuration, () {
      if (_context.mounted) {
        try {
          ScaffoldMessenger.of(_context).removeCurrentSnackBar();
        } catch (e) {
          // maybe do stuff but probably not neccessary
          //   This catch block only executes when the user bypasses the NFC availability check
          //   and has the button for NFC payments enabled in spite of not having NFC enabled
          //   on their device.
        }
      }
      _isShowing = false;
    });
  }

  static bool _isShowing = false;
  static AnimationController? _animCont;
  final Duration duration = const Duration(seconds: 4);
  final Duration _animForwardDuration = const Duration(milliseconds: 250);
  final Duration _animReverseDuration = const Duration(milliseconds: 150);

  void show(String displayText, {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    // had to add this line because of errors when scaffold for some reason doesn't register
    // as existing, so you can pass the key instead to avoid the error
    ScaffoldState scaffoldState = scaffoldKey?.currentState ?? Scaffold.of(_context);
    _animCont ??= AnimationController(
      vsync: scaffoldState,
      duration: _animForwardDuration,
      reverseDuration: _animReverseDuration,
    );

    if (_isShowing) {
      await clear();
    }

    if (_context.mounted) {
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          elevation: 0,
          content: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: _animCont!..forward(), curve: Curves.easeInOut)),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(CurvedAnimation(parent: _animCont!..forward(), curve: Curves.easeInOut)),
              child: Container(
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
          ),
        ),
      );
      Future.delayed(duration - _animReverseDuration, clear);
      _isShowing = true;
    }
  }
}
