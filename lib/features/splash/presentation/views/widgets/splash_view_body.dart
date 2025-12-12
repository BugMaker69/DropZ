import 'package:drop_z_ecommerce_app/core/utils/app_router.dart';
import 'package:drop_z_ecommerce_app/core/utils/assets.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/splash/presentation/manager/splash_cubit/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SplashCubit(getIt.get<SharedPreferences>())..checkAuth(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            if (state.role == "seller") {
              context.go(AppRouter.kSellerDashboard);
            } else {
              context.go(AppRouter.kCustomerHome);
            }
            // context.go(AppRouter.kHomeView);
            // context.replace(AppRouter.kHomeView);
          } else if (state is SplashUnauthenticated) {
            context.go(AppRouter.kloginView);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Center(child: Image.asset(AssetsData.logo))],
        ),
      ),
    );
  }
}
