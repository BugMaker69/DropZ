import 'package:bloc/bloc.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_request.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_success_response.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo.dart';
import 'package:equatable/equatable.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  RegisterRepo registerRepo;

  Future<void> registerWithEmailNPassword({
    required String email,
    required String userRole,
    required String firstName,
    required String lastName,
    required String password,
    required String confirmPassword,
  }) async {
    emit(RegisterLoading());

    var result = await registerRepo.registerWithEmailNPassword(
      RegisterRequest(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        role: userRole,
      ),
    );

    result.fold(
      (failure) {
        emit(RegisterFailure(failure.errMessage));
      },
      (registerSuccessResponse) {
        emit(RegisterSuccess(registerSuccessResponse));
      },
    );
  }
}
