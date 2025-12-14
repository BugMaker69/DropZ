import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_data_data.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_response.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/logout_message.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileRepoImp extends UserProfileRepo {
  final ApiService apiService;
  final SharedPreferences preferences;

  UserProfileRepoImp(this.apiService, this.preferences);

  @override
  Future<Either<Failure, GetUserDataSuccess>> getUserData() {
    return RepoRequest.call<GetUserDataSuccess>(
      request: () => apiService.get(endPoint: '/accounts/users/me/'),
      parser: (data) => GetUserDataSuccess.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, GetUserDataSuccess>> updateUserData(
    GetUserDataSuccess updateUserData,
  ) {
    return RepoRequest.call<GetUserDataSuccess>(
      request: () async {
        final formData = FormData.fromMap({
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

        final data = await apiService.patch(
          data: formData,
          endPoint: '/accounts/users/me/',
          isImage: true,
        );

        if (imageToUpload != null && imageToUpload.path.contains('temp_')) {
          try {
            await imageToUpload.delete();
          } catch (e) {
            debugPrint("Failed to delete temp image: $e");
          }
        }

        return data;
      },
      parser: (data) => GetUserDataSuccess.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, ChangePasswordResponse>> changePassword(
    ChangePasswordData password,
  ) {
    return RepoRequest.call<ChangePasswordResponse>(
      request: () => apiService.patch(
        endPoint: '/auth/change_password/',
        data: password.toJson(),
      ),
      parser: (data) => ChangePasswordResponse.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, LogoutMessage>> logOut() {
    return RepoRequest.call<LogoutMessage>(
      request: () async {
        final accessToken = preferences.getString("accessToken")!;
        final refreshToken = preferences.getString("refreshToken")!;

        final data = await apiService.post(
          endPoint: '/auth/logout/',
          token: accessToken,
          refreshToken: refreshToken,
        );

        await preferences.remove('accessToken');
        await preferences.remove('refreshToken');
        await preferences.remove('userId');
        await preferences.remove('userRole');
        await Hive.box('productsBox').clear();
        await Hive.box('categoriesBox').clear();
        await Hive.deleteFromDisk();

        return data;
      },
      parser: (data) => LogoutMessage.fromJson(data),
    );
  }
}
