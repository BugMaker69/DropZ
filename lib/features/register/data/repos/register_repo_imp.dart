import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_request.dart';
import 'package:drop_z_ecommerce_app/features/register/data/model/register_success_response.dart';
import 'package:drop_z_ecommerce_app/features/register/data/repos/register_repo.dart';

class RegisterRepoImp extends RegisterRepo {
  final ApiService apiService;
  RegisterRepoImp(this.apiService);

  @override
  Future<Either<Failure, RegisterSuccessResponse>> registerWithEmailNPassword(
    RegisterRequest registerRequest,
  ) {
    return RepoRequest.call<RegisterSuccessResponse>(
      request: () => apiService.post(
        endPoint: "/auth/register/",
        data: registerRequest.toJson(),
      ),
      parser: (data) => RegisterSuccessResponse.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, RegisterSuccessResponse>> registerWithGmail() {
    throw UnimplementedError();
  }
}
