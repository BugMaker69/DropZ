import 'package:device_preview/device_preview.dart';
import 'package:drop_z_ecommerce_app/core/providers/localization_provider.dart';
import 'package:drop_z_ecommerce_app/core/providers/theme_provider.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/my_observer.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/manager/login_cubit/login_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/products/presentation/manager/products_cubit/products_cubit.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/manager/user_profile_cubit/user_profile_cubit.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/manager/register_cubit/register_cubit.dart';
import 'package:drop_z_ecommerce_app/features/search/data/repos/search_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/repos/whishlist_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/presentation/manager/wish_list_cubit/wish_list_cubit.dart';
import 'package:drop_z_ecommerce_app/l10n/app_localizations.dart';
// import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
// import 'package:drop_z_ecommerce_app/features/login/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  Bloc.observer = MyCubitObserver(); // <--- هنا بنضيف الـ Observer

  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
        BlocProvider(
          create: (context) => LoginCubit(getIt.get<LoginRepoImp>()),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(getIt.get<RegisterRepoImp>()),
        ),
        BlocProvider(
          create: (context) =>
              ProductsCubit(getIt.get<ProductsRepoImp>())..loadAllData(),
          // ..getAllCategories()
          // ..getAllProducts(),
        ),
        BlocProvider(
          create: (context) => UserProfileCubit(
            getIt.get<UserProfileRepoImp>(),
            // getIt.get<SharedPreferences>(),
          )..getUserData(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(getIt.get<SearchRepoImp>()),
        ),
        BlocProvider(
          create: (context) =>
              CartCubit(getIt.get<CartRepoImp>())..getCartItems(),
        ),
        BlocProvider(
          create: (context) =>
              WishListCubit(getIt.get<WhishlistRepoImp>())..getAllWishList(),
        ),

        // BlocProvider(create: (context)=> HomeView()),
      ],
      child: Consumer2<ThemeProvider, LocalizationProvider>(
        builder: (context, themeProvider, localizationProvider, child) {
          return MaterialApp.router(
            // routerConfig: getIt.get<AppRouter>().router,
            routerConfig: AppRouter.router,
            title: AppLocalizations.of(context)?.appName ?? 'DropZ',
            useInheritedMediaQuery: true,
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            locale: localizationProvider.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            /*theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
              primaryColorLight: Colors.white,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              useMaterial3: true,
            ),*/
            // home: LoginView(),
          );
        },
      ),
    );
  }
}
