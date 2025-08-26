import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_request.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_success_response/login_success_response.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());

  final LoginRepo loginRepo;

  // void emailChanged(String email) {
  //   var current = state as LoginInitial;
  //   print(
  //     "Current ${current} ,CurrentEmail ${current.email} , Acctual Email $email ",
  //   );
  //   emit(current.copyWith(email: email));
  // }

  // void passwordChanged(String password) {
  //   var current = state as LoginInitial;
  //   print(
  //     "Current ${current} ,CurrentPassword ${current.password} , Acctual Password $password ",
  //   );

  //   emit(current.copyWith(password: password));
  // }

  // void emailChanged(String email) {
  //   if (state is LoginInitial) {
  //     var current = state as LoginInitial;
  //     emit((state as LoginInitial).copyWith(email: email));

  //     // emit(current.copyWith(email: email));
  //   }
  // }

  // void passwordChanged(String password) {
  //   if (state is LoginInitial) {
  //     var current = state as LoginInitial;
  //     emit((state as LoginInitial).copyWith(password: password));

  //     // emit(current.copyWith(password: password));
  //   }
  // }

  // void resetForm() {
  //   emit(LoginInitial());
  // }

  // Future<void> loginWithEmailNPassword(LoginRequest loginRequest) async {
  Future<void> loginWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    // if (state is LoginInitial) {
    //   var current = state as LoginInitial;

    // print(
    // "Current value loginWithEmailNPassword ${current} ,current.email:  ${current.email} , current.password : ${current.password}",
    // );

    emit(LoginLoading());

    var result = await loginRepo.loginWithEmailNPassword(
      LoginRequest(email: email, password: password),
    );
    // var result = await loginRepo.loginWithEmailNPassword(loginRequest);

    print("REsult ${result}");

    result.fold(
      (failure) {
        emit(LoginFailure(failure.errMessage));
      },
      (loginSuccessResponse) {
        emit(LoginSuccess(loginSuccessResponse));
      },
    );
    // }
    //  else {
    //   emit(LoginFailure('Invalid state'));
    // }
  }
}
