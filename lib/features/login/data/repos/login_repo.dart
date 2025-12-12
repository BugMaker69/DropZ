import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_request.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_success_response/login_success_response.dart';

abstract class LoginRepo {
  // Future<Either<Failure, LoginSuccessResponse>> loginWithEmailNPassword(
  Future<Either<Failure, String>> loginWithEmailNPassword(
    LoginRequest loginRequest,
  );
  Future<Either<Failure, LoginSuccessResponse>> loginWithGmail();
}
