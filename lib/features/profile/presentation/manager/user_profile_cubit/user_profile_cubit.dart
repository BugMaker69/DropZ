import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
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
    await CubitHandler.run<GetUserDataSuccess>(
      cubit: this,
      call: () => userProfileRepo.getUserData(),
      loadingState: () => emit(UserProfileLoading()),
      onSuccess: (data) => emit(UserProfileSuccess(data)),
      failureState: (msg) => emit(UserProfileFailure(msg)),
    );
  }

  Future<void> updateUserData(GetUserDataSuccess data) async {
    await CubitHandler.run<GetUserDataSuccess>(
      cubit: this,
      call: () => userProfileRepo.updateUserData(data),
      loadingState: () => emit(UserProfileLoading()),
      onSuccess: (data) => emit(UserProfileSuccess(data)),
      failureState: (msg) => emit(UserProfileFailure(msg)),
    );
  }

  Future<void> changePassword(ChangePasswordData password) async {
    await CubitHandler.run<ChangePasswordResponse>(
      cubit: this,
      call: () => userProfileRepo.changePassword(password),
      loadingState: () => emit(UserProfileLoading()),
      onSuccess: (data) => emit(ChangePasswordSuccess(data)),
      failureState: (msg) => emit(UserProfileFailure(msg)),
    );
  }

  Future<void> logOut() async {
    await CubitHandler.run<LogoutMessage>(
      cubit: this,
      call: () => userProfileRepo.logOut(),
      loadingState: () => emit(UserProfileLoading()),
      onSuccess: (data) => emit(AuthLoggedOut(data)),
      failureState: (msg) => emit(UserProfileFailure(msg)),
    );
  }
}
