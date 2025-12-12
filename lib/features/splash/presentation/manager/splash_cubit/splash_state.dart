part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

final class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final String role;
  const SplashAuthenticated(this.role);
}

class SplashUnauthenticated extends SplashState {}
