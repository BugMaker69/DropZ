// lib/core/utils/royal_page_transition.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animations/animations.dart';

class RoyalPageTransition extends CustomTransitionPage {
  RoyalPageTransition({
    required LocalKey key,
    required Widget child,
    this.type = RoyalTransitionType.slideParallax,
    this.duration = const Duration(milliseconds: 450),
  }) : super(
         key: key,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _buildTransition(animation, secondaryAnimation, child, type);
         },
       );

  final RoyalTransitionType type;
  final Duration duration;

  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    RoyalTransitionType type,
  ) {
    switch (type) {
      case RoyalTransitionType.slideParallax:
        return _parallaxSlide(animation, secondaryAnimation, child);
      case RoyalTransitionType.sharedAxis:
        return _sharedAxisTransition(animation, secondaryAnimation, child);
      case RoyalTransitionType.fadeScale:
        return _fadeScaleTransition(animation, secondaryAnimation, child);
      case RoyalTransitionType.slideFromBottom:
        return _slideFromBottom(animation, secondaryAnimation, child);
      default:
        return child;
    }
  }

  // 1. Parallax Slide (الأجمل)
  static Widget _parallaxSlide(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      children: [
        // الصفحة القديمة
        SlideTransition(
          position:
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.3, 0),
              ).animate(
                CurvedAnimation(parent: secondaryAnimation, curve: Curves.ease),
              ),
          child: FadeTransition(
            opacity: secondaryAnimation,
            child: const SizedBox(),
          ),
        ),
        // الصفحة الجديدة
        SlideTransition(
          position: Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: Material(
            elevation: 16,
            shadowColor: Colors.black38,
            borderRadius: BorderRadius.circular(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  // 2. Shared Axis (Material 3)
  static Widget _sharedAxisTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: child,
    );
  }

  // 3. Fade + Scale (للـ Product Details)
  static Widget _fadeScaleTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
        ),
        child: child,
      ),
    );
  }

  // 4. Slide from Bottom (للـ Checkout)
  static Widget _slideFromBottom(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}

enum RoyalTransitionType {
  slideParallax, // الأجمل
  sharedAxis, // Material 3
  fadeScale, // Product Details
  slideFromBottom, // Checkout
}
