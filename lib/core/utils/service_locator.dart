import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/address/data/repos/address_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/biometrics/data/repos/biometrics_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/cart/data/repos/cart_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/checkout/data/repos/checkout_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/products/data/repos/products_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/reviews/data/repos/products_review_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/search/data/repos/search_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/support/data/repos/ticket_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/whishlist/data/repos/whishlist_repo_imp.dart';
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
  getIt.registerSingleton<ProductsRepoImp>(
    ProductsRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<CartRepoImp>(CartRepoImp(getIt.get<ApiService>()));
  getIt.registerSingleton<WhishlistRepoImp>(
    WhishlistRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<SearchRepoImp>(
    SearchRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<ProductsReviewRepoImp>(
    ProductsReviewRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<AddressRepoImp>(
    AddressRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<CheckoutRepoImp>(
    CheckoutRepoImp(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<BiometricsRepoImp>(BiometricsRepoImp());
  getIt.registerSingleton<TicketRepoImp>(
    TicketRepoImp(getIt.get<ApiService>()),
  );
}
