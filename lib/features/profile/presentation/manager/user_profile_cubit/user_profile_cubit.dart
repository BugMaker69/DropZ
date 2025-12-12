import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_data_data.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/change_password_response.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/get_user_data_success.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/models/logout_message.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this.userProfileRepo) : super(UserProfileInitial());

  UserProfileRepo userProfileRepo;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String? profileImageUrl;

  void setUserData(GetUserDataSuccess data) {
    firstNameController.text = data.firstName ?? '';
    lastNameController.text = data.lastName ?? '';
    emailController.text = data.email ?? '';
    phoneController.text = data.phoneNumber ?? '';

    profileImageUrl = data.profileImage;

    emit(UserProfileSuccess(GetUserDataSuccess()));
  }

  Future<void> getUserData() async {
    emit(UserProfileLoading());

    var result = await userProfileRepo.getUserData(
      // preferences.getString("accessToken")!,
    );

    print("RESult : $result");

    result.fold(
      (failure) {
        emit(UserProfileFailure(failure.errMessage));
      },
      (getUserDataSuccess) {
        emit(UserProfileSuccess(getUserDataSuccess));
      },
    );
  }

  Future<void> updateUserData(
    // String token,
    GetUserDataSuccess updateUserData,
  ) async {
    emit(UserProfileLoading());

    var result = await userProfileRepo.updateUserData(updateUserData);
    // var result = await userProfileRepo.updateUserData(token, updateUserData);

    print("RESult : $result");

    result.fold(
      (failure) {
        emit(UserProfileFailure(failure.errMessage));
      },
      (getUserDataSuccess) {
        emit(UserProfileSuccess(getUserDataSuccess));
      },
    );
  }

  Future<void> changePassword(ChangePasswordData password) async {
    emit(UserProfileLoading());

    var result = await userProfileRepo.changePassword(password);

    print("RESult : $result");

    result.fold(
      (failure) {
        emit(UserProfileFailure(failure.errMessage));
      },
      (message) {
        emit(ChangePasswordSuccess(message));
      },
    );
  }

  //! Need To Be Handle in Efficent Way
  Future<void> logOut() async {
    emit(UserProfileLoading());

    var result = await userProfileRepo.logOut(
      // preferences.getString("accessToken")!,
      // preferences.getString("refreshToken")!,
    );
    print("RESult : $result");

    result.fold(
      (failure) {
        emit(UserProfileFailure(failure.errMessage));
      },
      (logoutSuccess) {
        // await preferences.remove('accessToken');
        // await preferences.remove('refreshToken');
        emit(AuthLoggedOut(logoutSuccess));
      },
    );
    // emit(AuthLoggedOut());
  }
}
