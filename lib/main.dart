import 'package:device_preview/device_preview.dart';
import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/login/presentation/manager/login_cubit/login_cubit.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/manager/user_profile_cubit/user_profile_cubit.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/register/presentation/manager/register_cubit/register_cubit.dart';
import 'package:drop_z_ecommerce_app/features/search/presentation/manager/search_cubit/search_cubit.dart';
// import 'package:drop_z_ecommerce_app/core/widgets/custom_edit_text.dart';
// import 'package:drop_z_ecommerce_app/features/login/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
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
        BlocProvider(
          create: (context) => LoginCubit(getIt.get<LoginRepoImp>()),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(getIt.get<RegisterRepoImp>()),
        ),
        BlocProvider(
          create: (context) => UserProfileCubit(
            getIt.get<UserProfileRepoImp>(),
            // getIt.get<SharedPreferences>(),
          ),
        ),
        BlocProvider(create: (context) => SearchCubit()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        title: 'DropZ',
        useInheritedMediaQuery: true,
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primaryColorLight: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        // home: LoginView(),
      ),
    );
  }
}
