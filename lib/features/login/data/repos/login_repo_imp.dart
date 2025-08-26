import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_request.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_success_response/login_success_response.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepoImp implements LoginRepo {
  final ApiService apiService;
  LoginRepoImp(this.apiService);

  @override
  Future<Either<Failure, LoginSuccessResponse>> loginWithEmailNPassword(
    LoginRequest loginRequest,
  ) async {
    print(
      "Login Request ${loginRequest} , ${loginRequest.email} , ${loginRequest.password}",
    );
    try {
      var result = await apiService.post(
        endPoint: "/auth/login/",
        data: loginRequest.toJson(),
        // loginRequest: loginRequest.toJson(),
      );

      print("DAta + ${result}");

      final data = result["data"];
      final cookies = result["cookies"] as List<String>?;

      // خزّن التوكنز في SharedPreferences هنا
      final accessToken = data['access'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);

      String? refreshToken;
      if (cookies != null) {
        for (var cookie in cookies) {
          if (cookie.startsWith('refresh_token=')) {
            refreshToken = cookie.split(';').first.split('=').last;
            await prefs.setString('refreshToken', refreshToken);
          }
        }
      }

      // print("response.data ${response.data}");
      print("refreshToken ${refreshToken}");

      LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse.fromJson(
        result,
      );
      print(
        "loginSuccessResponse   $loginSuccessResponse , ${loginSuccessResponse.access} , ${loginSuccessResponse.user}",
      );
      return right(loginSuccessResponse);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginSuccessResponse>> loginWithGmail() {
    // TODO: implement loginWithGmail
    throw UnimplementedError();
  }
}
