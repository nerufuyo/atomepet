import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Custom page transitions for the app
class AppTransitions {
  /// Fade transition
  static Transition fade = Transition.fade;

  /// Slide from right (default for navigation)
  static Transition rightToLeft = Transition.rightToLeft;

  /// Slide from left (for back navigation)
  static Transition leftToRight = Transition.leftToRight;

  /// Zoom transition
  static Transition zoom = Transition.zoom;

  /// Fade with zoom
  static Transition fadeIn = Transition.fadeIn;

  /// Custom slide up transition
  static Widget slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(position: animation.drive(tween), child: child);
  }

  /// Custom fade with scale transition
  static Widget fadeScaleTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeInOutCubic;

    var fadeAnimation = CurvedAnimation(parent: animation, curve: curve);

    var scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: curve));

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(scale: scaleAnimation, child: child),
    );
  }

  /// Custom slide and fade transition
  static Widget slideFadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutCubic;

    var slideAnimation = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: curve));

    var fadeAnimation = CurvedAnimation(parent: animation, curve: curve);

    return SlideTransition(
      position: animation.drive(slideAnimation),
      child: FadeTransition(opacity: fadeAnimation, child: child),
    );
  }

  /// Duration for transitions
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration slowDuration = Duration(milliseconds: 400);
}
