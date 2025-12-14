import 'package:device_preview/device_preview.dart';
import 'package:drop_z_ecommerce_app/core/payment/payment_cubit/payment_cubit.dart';
import 'package:drop_z_ecommerce_app/core/providers/localization_provider.dart';
import 'package:drop_z_ecommerce_app/core/providers/theme_provider.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/deep_link_cubit/deep_link_cubit.dart';
import 'package:drop_z_ecommerce_app/core/utils/my_observer.dart';
import 'package:drop_z_ecommerce_app/core/utils/network_cubit/network_cubit.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/address/presentation/manager/address_cubit/address_cubit.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/data/repos/biometrics_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/presentation/manager/biometric_cubit/biometrics_cubit.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/manager/login_cubit/login_cubit.dart';
import 'package:drop_z_ecommerce_app/features/checkout/data/repos/checkout_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/checkout/presentation/manager/checkout_cubit/checkout_cubit.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/category_model/category_model_adapter.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/product_item_data_model_adapter.dart';
import 'package:drop_z_ecommerce_app/features/products/data/model/product_item_data_model/result_adapter.dart';
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
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';

void main() async {
  Bloc.observer = MyCubitObserver(); // <--- هنا بنضيف الـ Observer

  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  await Hive.initFlutter();

  Hive.registerAdapter(ResultAdapter()); // product result item
  Hive.registerAdapter(ProductItemDataModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  await Hive.openBox('productsBox');
  await Hive.openBox('categoriesBox');

  final QuickActions quickActions = const QuickActions();

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
    }
  });

  quickActions.setShortcutItems([
    const ShortcutItem(
      type: 'action_search',
      localizedTitle: 'Search',
      icon: 'search', // اسم صورة بدون .png
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
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NetworkCubit()),
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
        BlocProvider(
          create: (context) => AddressCubit(getIt.get<AddressRepoImp>()),
        ),
        BlocProvider(create: (context) => DeepLinkCubit()),
        BlocProvider(
          //!
          create: (context) => PaymentCubit(getIt.get<ApiService>()),
        ),
        BlocProvider(
          create: (context) => CheckoutCubit(getIt.get<CheckoutRepoImp>()),
        ),
        BlocProvider(
          create: (context) => BiometricsCubit(getIt.get<BiometricsRepoImp>()),
        ),
        // BlocProvider(
        //   create: (context) => TicketCubit(getIt.get<TicketRepoImp>()),
        // ),

        // BlocProvider(create: (context)=> HomeView()),
      ],
      child: Consumer2<ThemeProvider, LocalizationProvider>(
        builder: (context, themeProvider, localizationProvider, child) {
          // final deepLinkCubit = getIt<DeepLinkCubit>();
          // deepLinkCubit.initDeepLinks(context);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<DeepLinkCubit>().initDeepLinks(context);
          });

          return MaterialApp.router(
            // showPerformanceOverlay: true,
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
