import 'package:drop_z_ecommerce_app/features/home/presentation/views/home_view.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/views/login_view.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/add_product_view.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/edit_product_item_view.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/views/widgets/product_item_details.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/views/profile_view.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/views/register_view.dart';
import 'package:drop_z_ecommerce_app/features/reviews/presentation/views/widgets/product_review_view.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/views/search_results_view.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/views/search_view.dart';
import 'package:drop_z_ecommerce_app/features/splash/presentation/views/on_boarding_view.dart';
import 'package:drop_z_ecommerce_app/features/splash/presentation/views/splash_view.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppRouter {
  static const kSplashView = '/';
  static const kloginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kHomeView = '/homeView';
  static const kProfileView = '/profileView';
  static const kSearchView = '/searchView';
  static const kSearchResultsView = '/searchResultsView';
  // static const kProductView = '/productView';
  static const kProductDetailsView = '/productDetailsView';
  static const kProductReviewsView = '/productReviewsView';
  static const kOnboardingView = '/onboarding';
  static const kAddproductView = '/addProduct';
  static const kEditDeleteProductView = '/editDeleteProduct';

  // static const kHomeView = '/';
  // static const kloginView = '/homeView';
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
      GoRoute(path: kHomeView, builder: (context, state) => const HomeView()),
      GoRoute(
        path: kProfileView,
        builder: (context, state) => const ProfileView(),
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
        path: kAddproductView,
        builder: (context, state) {
          final categories = state.extra as List<CategoryModel>;
          return AddProductView(categories: categories);
        },
      ),
      GoRoute(
        path: kEditDeleteProductView,
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
    ],
  );
}
