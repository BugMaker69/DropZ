import 'package:dartz/dartz.dart';
import 'package:drop_z_ecommerce_app/core/errors/failure.dart';
import 'package:drop_z_ecommerce_app/core/utils/api_service.dart';
import 'package:drop_z_ecommerce_app/core/utils/repo_request.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_request.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_success_response/login_success_response.dart';
import 'package:drop_z_ecommerce_app/features/login/data/repos/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class LoginRepoImp implements LoginRepo {
  final ApiService apiService;
  LoginRepoImp(this.apiService);

  @override
  Future<Either<Failure, String>> loginWithEmailNPassword(
    LoginRequest loginRequest,
  ) async {
    return RepoRequest.call(
      request: () async {
        final result = await apiService.post(
          endPoint: "/auth/login/",
          data: loginRequest.toJson(),
        );

        final data = result["data"];
        final cookies = result["cookies"] as List<String>?;

        // خزّن التوكنز في SharedPreferences
        final accessToken = data['access'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);

        Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
        String? userId = payload['user_id']?.toString();
        String? role = payload['role']?.toString();

        if (userId != null) await prefs.setString("userId", userId);
        if (role != null) await prefs.setString("userRole", role);

        if (cookies != null) {
          for (var cookie in cookies) {
            if (cookie.startsWith('refresh_token=')) {
              final refreshToken = cookie.split(';').first.split('=').last;
              await prefs.setString('refreshToken', refreshToken);
            }
          }
        }

        return role!;
      },
      parser: (role) => role,
    );
  }

  @override
  Future<Either<Failure, LoginSuccessResponse>> loginWithGmail() {
    throw UnimplementedError();
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }
}
