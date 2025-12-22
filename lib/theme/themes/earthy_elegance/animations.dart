// Earthy Elegance Theme - Animations
//
// iOS-like spring animations and smooth transitions.
// Provides natural, responsive feel to all interactions.

import 'package:flutter/material.dart';

class EarthyAnimations {
  // Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationPageTransition = Duration(milliseconds: 400);

  // Curves - iOS-like spring animations
  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveSpring = Curves.elasticOut;
  static const Curve curveEaseOut = Curves.easeOutCubic;
  static const Curve curveEaseIn = Curves.easeInCubic;
  static const Curve curveBounce = Curves.bounceOut;

  // Custom spring curve for buttons (mimics iOS feel)
  static const Curve curveButtonPress = Curves.easeOutBack;

  // Scale factors
  static const double buttonScalePressed = 0.95;
  static const double buttonScaleHover = 1.02;
  static const double cardScalePressed = 0.98;
  static const double cardScaleHover = 1.01;

  // Page transition builder - iOS-like slide with fade
  static Widget pageTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeOutCubic;

    var slideTween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: curve));
    var fadeTween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(slideTween),
      child: FadeTransition(opacity: animation.drive(fadeTween), child: child),
    );
  }

  // Fade transition builder
  static Widget fadeTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curveEaseOut),
      child: child,
    );
  }

  // Scale transition builder
  static Widget scaleTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: animation, curve: curveEaseOut),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
