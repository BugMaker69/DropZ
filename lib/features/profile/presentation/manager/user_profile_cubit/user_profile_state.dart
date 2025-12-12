part of 'user_profile_cubit.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

class AuthLoggedOut extends UserProfileState {
  final LogoutMessage logoutMessage;
  const AuthLoggedOut(this.logoutMessage);
}

final class UserProfileSuccess extends UserProfileState {
  final GetUserDataSuccess getUserDataSuccess;
  const UserProfileSuccess(this.getUserDataSuccess);
}

final class UserProfileFailure extends UserProfileState {
  final String errMessage;
  const UserProfileFailure(this.errMessage);
}

final class ChangePasswordSuccess extends UserProfileState {
  final ChangePasswordResponse message;
  const ChangePasswordSuccess(this.message);
}
