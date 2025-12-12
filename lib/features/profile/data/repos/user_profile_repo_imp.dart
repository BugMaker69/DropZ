import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_data_data.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_response.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/logout_message.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileRepoImp extends UserProfileRepo {
  ApiService apiService;
  SharedPreferences preferences;

  UserProfileRepoImp(this.apiService, this.preferences);

  @override
  Future<Either<Failure, GetUserDataSuccess>> getUserData() async {
    try {
      var data = await apiService.get(endPoint: '/accounts/users/me/');

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
    GetUserDataSuccess updateUserData,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "first_name": updateUserData.firstName,
        "last_name": updateUserData.lastName,
        "email": updateUserData.email,
        "phone_number": updateUserData.phoneNumber,
      });

      File? imageToUpload;

      if (updateUserData.profileImage != null) {
        imageToUpload = updateUserData.profileImage;
      } else if (updateUserData.profileImage != null &&
          updateUserData.profileImage!.isNotEmpty) {
        imageToUpload = await apiService.downloadImage(
          updateUserData.profileImage!,
        );
      }

      if (imageToUpload != null) {
        String fileName = imageToUpload.path.split('/').last;
        formData.files.add(
          MapEntry(
            'profile_image',
            await MultipartFile.fromFile(
              imageToUpload.path,
              filename: fileName,
            ),
          ),
        );
      }

      var data = await apiService.patch(
        data: formData,
        endPoint: '/accounts/users/me/',
        isImage: true,
      );

      if (imageToUpload != null && imageToUpload.path.contains('temp_')) {
        try {
          await imageToUpload.delete();
        } catch (e) {
          print("Failed to delete temp image: $e");
        }
      }

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
  Future<Either<Failure, ChangePasswordResponse>> changePassword(
    ChangePasswordData password,
  ) async {
    try {
      var data = await apiService.patch(
        data: password.toJson(),
        endPoint: '/auth/change_password/',
      );

      ChangePasswordResponse message = ChangePasswordResponse.fromJson(data);

      return right(message);
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
      final accessToken = await preferences.getString("accessToken")!;
      final refreshToken = await preferences.getString("refreshToken")!;

      var data = await apiService.post(
        endPoint: '/auth/logout/',
        token: accessToken,
        refreshToken: refreshToken,
        // data: {"refresh": preferences.getString("refreshToken")!},
      );

      // await Future.delayed(const Duration(seconds: 2));

      print("Logout DATA $data");

      await preferences.remove('accessToken');
      await preferences.remove('refreshToken');
      await preferences.remove('userId');
      await preferences.remove('userRole');

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
