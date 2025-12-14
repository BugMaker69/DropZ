import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
//! Change + Edit

Future<void> setupQuickActions() async {
  final prefs = await SharedPreferences.getInstance();
  final userRole = prefs.getString("userRole"); // "customer" أو "seller"
  final isLoggedIn = prefs.getString("accessToken") != null;

  final quickActions = QuickActions();

  if (!isLoggedIn) {
    // مش مسجل دخول → ممكن نخلي القائمة فارغة أو لا تعرض
    quickActions.setShortcutItems([]);
    return;
  }

  // نحدد العناصر حسب الدور
  List<ShortcutItem> shortcutItems = [];

  if (userRole == "customer") {
    shortcutItems = [
      const ShortcutItem(
        type: 'action_search',
        localizedTitle: 'Search',
        icon: 'search',
      ),
      const ShortcutItem(
        type: 'action_cart',
        localizedTitle: 'Cart',
        icon: 'cart',
      ),
      const ShortcutItem(
        type: 'action_profile',
        localizedTitle: 'Profile',
        icon: 'profile',
      ),
    ];
  } else if (userRole == "seller") {
    shortcutItems = [
      const ShortcutItem(
        type: 'action_add_product',
        localizedTitle: 'Add Product',
        icon: 'add_product',
      ),
      const ShortcutItem(
        type: 'action_orders',
        localizedTitle: 'Orders',
        icon: 'orders',
      ),
      const ShortcutItem(
        type: 'action_profile',
        localizedTitle: 'Profile',
        icon: 'profile',
      ),
    ];
  }

  // تهيئة الـ quick actions
  quickActions.initialize((shortcutType) {
    switch (shortcutType) {
      case 'action_search':
        print("Open Search Screen");
        // GoRouter.of(context).go(AppRouter.searchView);
        break;
      case 'action_cart':
        print("Open Cart Screen");
        // GoRouter.of(context).go(AppRouter.cartView);
        break;
      case 'action_profile':
        print("Open Profile Screen");
        // GoRouter.of(context).go(AppRouter.profileView);
        break;
      case 'action_add_product':
        print("Open Add Product Screen");
        // GoRouter.of(context).go(AppRouter.addProductView);
        break;
      case 'action_orders':
        print("Open Orders Screen");
        // GoRouter.of(context).go(AppRouter.ordersView);
        break;
    }
  });

  quickActions.setShortcutItems(shortcutItems);
}
