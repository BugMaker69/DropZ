import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_request.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_success_response.dart';

abstract class RegisterRepo {
  Future<Either<Failure, RegisterSuccessResponse>> registerWithEmailNPassword(
    RegisterRequest registerRequest,
  );
  Future<Either<Failure, RegisterSuccessResponse>> registerWithGmail();
}
