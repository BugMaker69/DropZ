import 'package:drop_z_ecommerce_app/features/home/presentation/views/home_view.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/views/login_view.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/views/profile_view.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/views/register_view.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/views/search_view.dart';
import 'package:drop_z_ecommerce_app/features/splash/presentation/views/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kSplashView = '/';
  static const kloginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kHomeView = '/homeView';
  static const kProfileView = '/profileView';
  static const kSearchView = '/searchView';

  // static const kHomeView = '/';
  // static const kloginView = '/homeView';
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kSplashView,
        builder: (context, state) => const SplashView(),
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
    ],
  );
}
