import 'package:drop_z_ecommerce_app/core/payment/payment_failed_page.dart';
import 'package:drop_z_ecommerce_app/core/payment/payment_success_page.dart';
import 'package:drop_z_ecommerce_app/features/address/data/model/address_response/address_response.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/address_view.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/add_address_item.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/views/widgets/edit_address_item.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/views/cart_view.dart';
import 'package:drop_z_ecommerce_app/features/home/presentation/views/customer/customer_scaffold.dart';
import 'package:drop_z_ecommerce_app/features/home/presentation/views/home_view.dart';
import 'package:drop_z_ecommerce_app/features/home/presentation/views/seller/seller_dashboard.dart';
import 'package:drop_z_ecommerce_app/features/home/presentation/views/seller/seller_scaffold.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/views/login_view.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/views/checkout_view.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/views/widgets/payment_web_view_page.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/add_product_view.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/edit_product_item_view.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_item_details.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/views/change_password.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/views/profile_view.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/views/register_view.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/product_review_view.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/views/search_results_view.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/views/search_view.dart';
import 'package:drop_z_ecommerce_app/features/settings/presentation/views/settings_view.dart';
import 'package:drop_z_ecommerce_app/features/splash/presentation/views/on_boarding_view.dart';
import 'package:drop_z_ecommerce_app/features/splash/presentation/views/splash_view.dart';
import 'package:drop_z_ecommerce_app/features/support/data/model/show_tickets/show_tickets.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/manager/ticket_cubit/ticket_cubit.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/views/support_view.dart';
import 'package:drop_z_ecommerce_app/features/support/presentation/views/widgets/ticket_details_item.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/views/wish_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppRouter {
  static const kSplashView = '/';
  static const kloginView = '/loginView';
  static const kRegisterView = '/registerView';
  // static const kHomeView = '/homeView';
  static const kCustomerProfileView = '/customer/profileView';
  static const kSellerProfileView = '/seller/profileView';
  static const kSearchView = '/searchView';
  static const kSearchResultsView = '/searchResultsView';
  // static const kProductView = '/productView';
  static const kProductDetailsView = '/productDetailsView';
  static const kProductReviewsView = '/productReviewsView';
  static const kOnboardingView = '/onboarding';
  static const kSellerAddproductView = '/seller/addProduct';
  static const kSellerEditDeleteProductView = '/seller/editDeleteProduct';
  static const kCustomerHome = '/customer/homeView';
  static const kCustomerSettingsView = '/customer/settingsView';
  static const kSellerSettingsView = '/seller/settingsView';
  static const kSellerDashboard = '/seller/homeView';
  static const kCustomerCartView = '/customer/cartView';
  static const kCustomerWishlistView = '/customer/wishlistView';
  static const kCustomerAddAddress = '/customer/addAddress';
  static const kCustomerEditAddress = '/customer/editAddress';
  static const kCustomerAddress = '/customer/address';
  static const kCustomerChangePassword = '/customer/changePassword';
  static const kSellerChangePassword = '/seller/changePassword';
  static const kCustomerCheckout = '/customer/checkoutView';
  static const kCustomerSupport = '/customer/support';
  static const kCustomerSupportDetails = '/customer/supportDetails';
  static const kCustomerPaymentWebView = '/customer/paymentWebView';
  static const kCustomerPaymentSuccess = '/customer/paymentSuccess';
  static const kCustomerPaymentFailed = '/customer/paymentFailed';

  static final router = GoRouter(
    initialLocation: kSplashView,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final showOnboarding = !(prefs.getBool('onboarding_completed') ?? false);
      if (showOnboarding && state.matchedLocation != kOnboardingView) {
        return kOnboardingView;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: kloginView, builder: (context, state) => const LoginView()),
      GoRoute(
        path: kRegisterView,
        builder: (context, state) => const RegisterView(),
      ),

      ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
          key: state.pageKey,
          child: CustomerScaffold(child: child),
        ),
        routes: [
          GoRoute(
            path: AppRouter.kCustomerHome,
            pageBuilder: (_, state) =>
                NoTransitionPage(key: state.pageKey, child: const HomeView()),
          ),
          GoRoute(
            path: AppRouter.kCustomerCartView,
            pageBuilder: (_, state) =>
                NoTransitionPage(key: state.pageKey, child: CartView()),
          ),
          GoRoute(
            path: AppRouter.kCustomerWishlistView,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const WishListView(),
            ),
          ),
          GoRoute(
            path: AppRouter.kCustomerSettingsView,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsView(userRole: "customer"),
            ),
          ),
        ],
      ),

      ShellRoute(
        builder: (context, state, child) => SellerScaffold(child: child),
        routes: [
          GoRoute(
            path: kSellerDashboard,
            builder: (_, __) => const SellerDashboard(),
          ),
          GoRoute(
            path: kSellerAddproductView,
            builder: (context, state) {
              final categories = state.extra as List<CategoryModel>;
              return AddProductView(categories: categories);
            },
          ),
          GoRoute(
            path: kSellerSettingsView,
            builder: (_, __) => const SettingsView(userRole: "seller"),
          ),

        ],
      ),
      GoRoute(
        path: kSellerProfileView,
        builder: (_, __) => const ProfileView(),
      ),

      GoRoute(
        path: kSearchView,
        builder: (context, state) => const SearchView(),
      ),
      GoRoute(
        path: kSearchResultsView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SearchResultsView(
            query: extra['query'] as String,
            products: extra['products'] as ProductItemDataModel,
          );
        },
      ),

      GoRoute(
        path: kSellerEditDeleteProductView,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          final categories = extras["categories"] as List<CategoryModel>;
          final product = extras["product"] as Result;
          return EditProductItemView(categories: categories, product: product);
        },
      ),
      GoRoute(
        path: kProductDetailsView,
        builder: (context, state) {
          final product = state.extra as Result;
          return ProductItemDetails(filteredProduct: product);
        },
      ),

      GoRoute(
        path: kProductReviewsView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ProductReviewView(
            slug: extra['slug'] as String,
            productId: extra['productId'] as int,
          );
        },
      ),

      GoRoute(
        path: kCustomerAddress,
        builder: (context, state) => const AddressView(),
      ),

      GoRoute(
        path: kCustomerCheckout,
        builder: (context, state) => const CheckoutView(),
      ),

      GoRoute(
        path: kCustomerEditAddress,
        builder: (context, state) {
          final addressData = state.extra as AddressResponse;
          return EditAddressItem(addressResponse: addressData);
        },
      ),

      GoRoute(
        path: kCustomerAddAddress,
        builder: (context, state) => const AddAddressItem(),
      ),
      GoRoute(
        path: kCustomerChangePassword,
        builder: (context, state) => const ChangePassword(),
      ),
      GoRoute(
        path: kSellerChangePassword,
        builder: (context, state) => const ChangePassword(),
      ),
      GoRoute(
        path: kCustomerPaymentSuccess,
        builder: (context, state) => const PaymentSuccessPage(),
      ),
      GoRoute(
        path: kCustomerPaymentFailed,
        builder: (context, state) => const PaymentFailedPage(),
      ),
      GoRoute(
        path: kCustomerSupport,
        builder: (context, state) => SupportView(),
      ),
      GoRoute(
        path: kCustomerProfileView,
        builder: (context, state) => ProfileView(),
      ),

      GoRoute(
        path: kCustomerSupportDetails,
        builder: (context, state) {
          final data = state.extra as Map;
          final ticket = data["ticket"] as ShowTickets;
          final cubit = data["cubit"] as TicketCubit;

          return BlocProvider.value(
            value: cubit,
            child: TicketDetailsItem(intialShowTicket: ticket),
          );
        },
      ),

      GoRoute(
        path: kCustomerPaymentWebView,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentWebViewPage(
            iframeUrl: extra['url'] as String,
            orderId: extra['orderId'] as int,
          );
        },
      ),

      GoRoute(
        path: "/product/:id",
        builder: (context, state) {
          final id = state.pathParameters["id"]!;
          return ProductItemDetails(
            id: int.tryParse(id),
            filteredProduct: Result(),
          );
        },
      ),
    ],
  );
}
