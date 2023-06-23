import 'package:flutter/cupertino.dart';

class ScreenTransitions {
  static const fromLeft = Offset(-1, 0);
  static const fromTop = Offset(0, -1);
  static const fromRight = Offset(1, 0);
  static const fromBottom = Offset(0, 1);

  static const zero = Offset.zero;

  /// Horizontal navigation animations
  static Widget Function(Widget anim, Animation<double> c) navAnimH(
          bool direction) =>
      direction ? ScreenTransitions.navLeft : ScreenTransitions.navRight;

  /// Vertical navigation animations
  static Widget Function(Widget anim, Animation c) navAnimV(bool direction) =>
      direction ? ScreenTransitions.navUp : ScreenTransitions.navDown;

  static SlideTransition navLeft(child, a) => SlideTransition(
      position: tween(fromRight, zero).animate(a), child: child);

  static SlideTransition navRight(child, a) =>
      SlideTransition(position: tween(fromLeft, zero).animate(a), child: child);

  static SlideTransition navUp(child, a) => SlideTransition(
      position: tween(fromBottom, zero).animate(a), child: child);

  static SlideTransition navDown(child, a) =>
      SlideTransition(position: tween(fromTop, zero).animate(a), child: child);

  static SlideTransition slideUp(context, anim, secondaryAnim, child) {
    return SlideTransition(
      position: tween(fromBottom, zero).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideDown(context, anim, secondaryAnim, child) {
    return SlideTransition(
      position: tween(fromTop, zero).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideLeft(context, anim, secondaryAnim, child) {
    return SlideTransition(
      position: tween(fromRight, zero).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideRight(context, anim, secondaryAnim, child) {
    return SlideTransition(
      position: tween(fromLeft, zero).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideInLeft(context, anim, secondaryAnim, child) {
    anim.reverse();
    return SlideTransition(
      position: tween(zero, fromRight).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideInRight(context, anim, secondaryAnim, child) {
    anim.reverse();
    return SlideTransition(
      position: tween(zero, fromRight).animate(anim),
      child: child,
    );
  }

  static Animation<Offset> pageFlipAnimation(controller, bool d) =>
      d ? _slideLeft(controller) : _slideRight(controller);

  static Animation<Offset> _slideRight(AnimationController controller) =>
      tween(fromLeft, zero).animate(controller);

  static Animation<Offset> _slideLeft(AnimationController controller) =>
      tween(fromRight, zero).animate(controller);

  static tween(Offset begin, Offset end) => Tween(begin: begin, end: end);
}
