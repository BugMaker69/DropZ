import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/logout_message.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/update_user_data.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileRepoImp extends UserProfileRepo {
  ApiService apiService;
  SharedPreferences preferences;

  UserProfileRepoImp(this.apiService, this.preferences);

  @override
  Future<Either<Failure, GetUserDataSuccess>> getUserData(
    // String token
  ) async {
    try {
      var data = await apiService.get(
        preferences.getString("accessToken")!,
        endPoint: '/accounts/users/me/',
      );

      GetUserDataSuccess getUserDataSuccess = GetUserDataSuccess.fromJson(data);

      return right(getUserDataSuccess);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetUserDataSuccess>> updateUserData(
    // String token,
    GetUserDataSuccess updateUserData,
  ) async {
    try {
      var data = await apiService.patch(
        data: updateUserData.toUpdateJson(),
        preferences.getString("accessToken")!,
        endPoint: '/accounts/users/me/',
      );

      GetUserDataSuccess getUserDataSuccess = GetUserDataSuccess.fromJson(data);

      return right(getUserDataSuccess);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LogoutMessage>> logOut(
    // String token,
    // String refreshToken,
  ) async {
    try {
      print(
        "refreshToken Before Delete ${preferences.getString("refreshToken")!}",
      );
      print(
        "accessToken Before Delete ${preferences.getString("accessToken")!}",
      );
      final accessToken = preferences.getString("accessToken")!;

      var data = await apiService.post(
        endPoint: '/auth/logout/',
        token: accessToken,
        // data: {"refresh": preferences.getString("refreshToken")!},
      );

      // await Future.delayed(const Duration(seconds: 2));

      await preferences.remove('accessToken');
      await preferences.remove('refreshToken');

      LogoutMessage logoutMessage = LogoutMessage.fromJson(data);

      return right(logoutMessage);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
