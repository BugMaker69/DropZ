import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SellerScaffold extends StatelessWidget {
  final Widget child;
  const SellerScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seller Panel")),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          NavigationDestination(icon: Icon(Icons.add_box), label: "Add"),
          NavigationDestination(icon: Icon(Icons.list), label: "Products"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),

          // NavigationDestination(
          //   icon: Icon(Icons.shopping_bag),
          //   label: "Orders",
          // ),
        ],
      ),
    );
  }

  int _getIndex(BuildContext context) {
    final location = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.last.matchedLocation;
    if (location == AppRouter.kSellerDashboard) return 0;
    if (location == AppRouter.kSellerAddproductView) return 1;
    //!Need To Be Edit
    if (location == AppRouter.kSellerAddproductView) return 2;
    if (location == AppRouter.kSellerSettingsView) return 3;
    // if (location == AppRouter.kSellerProducts) return 2;
    // if (location == AppRouter.kSellerOrders) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int i) async {
    final routes = [
      AppRouter.kSellerDashboard,
      AppRouter.kSellerAddproductView,
      //!Need To Be Edit
      AppRouter.kSellerAddproductView,
      AppRouter.kSellerSettingsView,

      // kSellerProducts,
      // kSellerOrders,
    ];

    if (i == 1) {
      // لما تضغط "Add" → احمل الـ categories أولاً
      final cubit = context.read<ProductsCubit>();
      await cubit.getAllCategories();

      if (cubit.categories != null && cubit.categories!.isNotEmpty) {
        context.go(routes[i], extra: cubit.categories);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load categories")),
        );
      }
    } else
      context.go(routes[i]);
  }
}
