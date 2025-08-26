import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo_imp.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPrefs);

  getIt.registerSingleton<ApiService>(
    ApiService(Dio(), getIt.get<SharedPreferences>()),
  );
  getIt.registerSingleton<LoginRepoImp>(LoginRepoImp(getIt.get<ApiService>()));
  getIt.registerSingleton<RegisterRepoImp>(
    RegisterRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<UserProfileRepoImp>(
    UserProfileRepoImp(getIt.get<ApiService>(), getIt.get<SharedPreferences>()),
  );
}
