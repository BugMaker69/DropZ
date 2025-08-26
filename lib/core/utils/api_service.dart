import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/utils/decode_jwt.dart';
import 'package:drop_z_ecommerce_app/features/login/data/model/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // final _baseUrl = 'http://localhost:8000/api/';
  // final _baseUrl = 'http://10.0.2.2:8000/api';   // For Emulator Phone
  final _baseUrl = 'http://192.168.1.3:8000/api';   // For My Real Mobile Phone

  final Dio _dio;
  final SharedPreferences preferences;

  ApiService(this._dio, this.preferences);

  Future<Map<String, dynamic>> post({
    required String endPoint,
    // required LoginRequest loginRequest,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
    var response = await _dio.post(
      '$_baseUrl$endPoint',
      data: data,
      // data: loginRequest,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    print("response DAta From API ${response.data}");

    return {
      "data": response.data,
      "cookies":
          response.headers.map['set-cookie'], // بترجع للـ Repo يتصرف بيها
      // "cookies": response.headers['set-cookie'], // بترجع للـ Repo يتصرف بيها
    };

    // final accessToken = response.data['access'];
    // await preferences.setString('accessToken', accessToken);

    // final cookies = response.headers['set-cookie'];
    // String? refreshToken;
    // if (cookies != null) {
    //   for (var cookie in cookies) {
    //     if (cookie.startsWith('refresh_token=')) {
    //       refreshToken = cookie.split(';').first.split('=').last;
    //       await preferences.setString('refreshToken', refreshToken);
    //     }
    //   }
    //   final decoded = decodeJwtPayload(refreshToken!);
    //   final role = decoded['role'];
    //   print("role ${role}");

    //   await preferences.setString('role', role);
    // }

    // print("response.data ${response.data}");
    // print("refreshToken ${refreshToken}");
    // print(
    //   "refreshToken From preferences ${preferences.getString("refreshToken")}",
    // );
    // print(
    //   "AccessToken From preferences ${preferences.getString("accessToken")}",
    // );
    // return response.data;
  }

  Future<Map<String, dynamic>> get(
    String? token, {
    required String endPoint,
  }) async {
    var response = await _dio.get(
      '$_baseUrl$endPoint',
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response.data GET ${response.data}");
    return response.data;
  }

  Future<Map<String, dynamic>> patch(
    String? token, {
    required String endPoint,
    Map<String, dynamic>? data,
  }) async {
    var response = await _dio.patch(
      '$_baseUrl$endPoint',
      data: data,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response.data GET ${response.data}");
    return response.data;
  }
}
