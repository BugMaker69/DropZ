import 'package:drop_z_ecommerce_app/constants.dart';
import 'package:drop_z_ecommerce_app/core/providers/theme_provider.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/widgets/custom_snakebar_message.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SellerScaffold extends StatelessWidget {
  final Widget child;
  const SellerScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text("${localizations.sellerPanel}"),
        actions: [
          // 🌙 Theme Toggle
          IconButton(
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(
                context,
                listen: false,
              );
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode_outlined,
            ),
            iconSize: 32,
            color: kSecondaryColor,
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getIndex(context),
        onDestinationSelected: (i) => _onTap(context, i),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: "${localizations.dashboard}",
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box),
            label: "${localizations.add}",
          ),
          // NavigationDestination(icon: Icon(Icons.list), label: "Products"),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "${localizations.settings}",
          ),

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
    // if (location == AppRouter.kSellerAddproductView) return 2;
    if (location == AppRouter.kSellerSettingsView) return 2;
    // if (location == AppRouter.kSellerProducts) return 2;
    // if (location == AppRouter.kSellerOrders) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int i) async {
    final routes = [
      AppRouter.kSellerDashboard,
      AppRouter.kSellerAddproductView,
      //!Need To Be Edit
      // AppRouter.kSellerAddproductView,
      AppRouter.kSellerSettingsView,

      // kSellerProducts,
      // kSellerOrders,
    ];

    if (i == 1) {
      // لما تضغط "Add" → احمل الـ categories أولاً
      final cubit = context.read<ProductsCubit>();
      final cats = await cubit.loadCategoriesForAddProduct();

      if (cats != null && cats.isNotEmpty) {
        context.go(routes[i], extra: cats);
      } else {
        CustomSnakeBar(context, "Failed to load categories");
      }
    } else {
      context.go(routes[i]);
    }
  }
}
