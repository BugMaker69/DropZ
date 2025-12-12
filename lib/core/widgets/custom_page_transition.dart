// lib/core/utils/custom_page_transition.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomPageTransition extends CustomTransitionPage {
  CustomPageTransition({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TransitionType type = TransitionType.slideFromRight,
  }) : super(
         key: key,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           switch (type) {
             case TransitionType.slideFromRight:
               return _slideTransition(
                 animation,
                 secondaryAnimation,
                 child,
                 curve,
               );
             case TransitionType.fade:
               return _fadeTransition(animation, secondaryAnimation, child);
             case TransitionType.scale:
               return _scaleTransition(animation, secondaryAnimation, child);
             case TransitionType.slideFromBottom:
               return _slideFromBottom(
                 animation,
                 secondaryAnimation,
                 child,
                 curve,
               );
             default:
               return child;
           }
         },
       );

  static Widget _slideTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Curve curve,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  static Widget _fadeTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget _scaleTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(scale: animation, child: child);
  }

  static Widget _slideFromBottom(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    Curve curve,
  ) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    final offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

enum TransitionType { slideFromRight, fade, scale, slideFromBottom }
