import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum PageAnimationType { slideFromRight, slideFromBottom, fade, fadeScale }

class CustomAnimatedPage<T> extends CustomTransitionPage<T> {
  CustomAnimatedPage({
    required super.child,
    required LocalKey super.key,
    PageAnimationType animationType = PageAnimationType.slideFromRight,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           switch (animationType) {
             case PageAnimationType.slideFromRight:
               return SlideTransition(
                 position:
                     Tween<Offset>(
                       begin: const Offset(1, 0),
                       end: Offset.zero,
                     ).animate(
                       CurvedAnimation(
                         parent: animation,
                         curve: Curves.easeInOut,
                       ),
                     ),
                 child: child,
               );
             case PageAnimationType.slideFromBottom:
               return SlideTransition(
                 position:
                     Tween<Offset>(
                       begin: const Offset(0, 1),
                       end: Offset.zero,
                     ).animate(
                       CurvedAnimation(
                         parent: animation,
                         curve: Curves.easeInOut,
                       ),
                     ),
                 child: child,
               );
             case PageAnimationType.fade:
               return FadeTransition(opacity: animation, child: child);
             case PageAnimationType.fadeScale:
               return FadeTransition(
                 opacity: animation,
                 child: ScaleTransition(
                   scale: Tween<double>(begin: 0.95, end: 1).animate(
                     CurvedAnimation(
                       parent: animation,
                       curve: Curves.easeInOut,
                     ),
                   ),
                   child: child,
                 ),
               );
           }
         },
       );
}
