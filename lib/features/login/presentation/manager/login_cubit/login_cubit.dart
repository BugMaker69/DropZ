import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/core/utils/cubit_handler.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_request.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.loginRepo) : super(LoginInitial());

  final LoginRepo loginRepo;

  Future<void> loginWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    await CubitHandler.run<String>(
      cubit: this,
      call: () => loginRepo.loginWithEmailNPassword(
        LoginRequest(email: email, password: password),
      ),
      onSuccess: (role) => emit(LoginSuccess(role)),
      onError: (msg) => emit(LoginFailure(msg)),
      loadingState: () => emit(LoginLoading()),
      failureState: (msg) => emit(LoginFailure(msg)),
    );
  }
}
