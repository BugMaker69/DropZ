import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_request.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_success_response.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo.dart';

class RegisterRepoImp extends RegisterRepo {
  final ApiService apiService;
  RegisterRepoImp(this.apiService);

  @override
  Future<Either<Failure, RegisterSuccessResponse>> registerWithEmailNPassword(
    RegisterRequest registerRequest,
  ) async {
    try {
      var data = await apiService.post(
        endPoint: "/auth/register/",
        data: registerRequest.toJson(),
      );

      RegisterSuccessResponse registerSuccessResponse =
          RegisterSuccessResponse.fromJson(data);
      return Right(registerSuccessResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterSuccessResponse>> registerWithGmail() {
    // TODO: implement signupWithGmail
    throw UnimplementedError();
  }
}
