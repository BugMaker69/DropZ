part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}
// final class LoginInitial extends LoginState {
//   final String email;
//   final String password;

//   LoginInitial({this.email = '', this.password = ''});

//   LoginInitial copyWith({String? email, String? password}) {
//     return LoginInitial(
//       email: email ?? this.email,
//       password: password ?? this.password,
//     );
//   }
// }

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginSuccessResponse loginSuccessResponse;

  LoginSuccess(this.loginSuccessResponse);
}

final class LoginFailure extends LoginState {
  final String errMessage;

  LoginFailure(this.errMessage);
}

// part of 'login_cubit.dart';

// sealed class LoginState extends Equatable {
//   const LoginState();

//   @override
//   List<Object?> get props => [];
//   // List<Object> get props => [];
// }

// final class LoginInitial extends LoginState {}
// // final class LoginInitial extends LoginState {
// //   final String email;
// //   final String password;

// //   LoginInitial({this.email = '', this.password = ''});

// //   LoginInitial copyWith({String? email, String? password}) {
// //     return LoginInitial(
// //       email: email ?? this.email,
// //       password: password ?? this.password,
// //     );
// //   }
// // }

// final class LoginForm extends LoginState {
//   final String email;
//   final String password;

//   const LoginForm({this.email = '', this.password = ''});

//   LoginForm copyWith({String? email, String? password}) {
//     return LoginForm(
//       email: email ?? this.email,
//       password: password ?? this.password,
//     );
//   }

//   @override
//   List<Object?> get props => [email, password];
// }

// final class LoginLoading extends LoginState {}

// final class LoginSuccess extends LoginState {
//   final LoginSuccessResponse loginSuccessResponse;

//   LoginSuccess(this.loginSuccessResponse);

//   @override
//   List<Object?> get props => [loginSuccessResponse];
// }

// final class LoginFailure extends LoginState {
//   final String errMessage;

//   LoginFailure(this.errMessage);

//   @override
//   List<Object?> get props => [errMessage];
// }
