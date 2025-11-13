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
  AuthLoggedOut(this.logoutMessage);
}

final class UserProfileSuccess extends UserProfileState {
  final GetUserDataSuccess getUserDataSuccess;
  UserProfileSuccess(this.getUserDataSuccess);
}

final class UserProfileFailure extends UserProfileState {
  final String errMessage;
  UserProfileFailure(this.errMessage);
}
