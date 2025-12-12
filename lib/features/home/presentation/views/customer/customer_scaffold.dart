import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerScaffold extends StatelessWidget {
  final Widget child;
  const CustomerScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: "Cart"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Wishlist"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.last.matchedLocation;
    if (location == AppRouter.kCustomerHome) return 0;
    if (location == AppRouter.kCustomerCartView) return 1;
    if (location == AppRouter.kCustomerWishlistView) return 2;
    if (location == AppRouter.kCustomerSettingsView) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int i) {
    final routes = [
      AppRouter.kCustomerHome,
      AppRouter.kCustomerCartView,
      AppRouter.kCustomerWishlistView,
      AppRouter.kCustomerSettingsView,
    ];
    context.go(routes[i]);
  }
}



/*
class CustomerScaffold extends StatelessWidget {
  final Widget child;
  const CustomerScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: KeyedSubtree(
          key: ValueKey(child.runtimeType), // كل صفحة مفتاحها مختلف
          child: child,
        ),
        transitionBuilder: (child, animation) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(1, 0), // Slide من اليمين
            end: Offset.zero,
          ).animate(animation);

          final fadeAnimation = Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation);

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: "Cart"),
          NavigationDestination(icon: Icon(Icons.favorite), label: "Wishlist"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.last.matchedLocation;
    if (location == AppRouter.kCustomerHome) return 0;
    if (location == AppRouter.kCustomerCartView) return 1;
    if (location == AppRouter.kCustomerWishlistView) return 2;
    if (location == AppRouter.kCustomerSettingsView) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int i) {
    final routes = [
      AppRouter.kCustomerHome,
      AppRouter.kCustomerCartView,
      AppRouter.kCustomerWishlistView,
      AppRouter.kCustomerSettingsView,
    ];
    context.go(routes[i]);
  }
}


*/