import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drop_z_ecommerce_app/core/utils/service_locator.dart';
import 'package:drop_z_ecommerce_app/features/profile/data/repos/user_profile_repo_imp.dart';
import 'package:drop_z_ecommerce_app/features/profile/presentation/manager/user_profile_cubit/user_profile_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // final _baseUrl = 'http://localhost:8000/api/';
  // final _baseUrl = 'http://10.0.2.2:8000/api'; // For Emulator Phone
  // final _baseUrl = 'http://192.168.1.7:8000/api'; // For My Real Mobile Phone
  final _baseUrl =
      'https://uncondemnable-brianna-hazelly.ngrok-free.dev/api'; // For My Real Mobile Phone Using Ngrok

  final Dio _dio;
  final SharedPreferences preferences;
  Future<bool>? _refreshTokenFuture;

  ApiService(this._dio, this.preferences) {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = preferences.getString("accessToken");
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            _refreshTokenFuture ??= _refreshToken();

            final success = await _refreshTokenFuture;

            // Reset future after finish
            _refreshTokenFuture = null;

            if (success!) {
              final newAccessToken = preferences.getString("accessToken");

              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              final clonedRequest = await _dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                ),
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );
              return handler.resolve(clonedRequest);
            }
            await UserProfileCubit(getIt.get<UserProfileRepoImp>()).logOut();
            return handler.reject(error);
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    String? newUrl,
    dynamic data,
    String? token,
    String? refreshToken,
    bool? isImage = false,
  }) async {
    var response = await _dio.post(
      newUrl == null ? '$_baseUrl$endPoint' : '$newUrl$endPoint',
      data: data,
      options: Options(
        headers: {
          "Content-Type": isImage == false
              ? "application/json"
              : "multipart/form-data",
          "Authorization": token != null ? "Bearer $token" : "",
          "Cookie": refreshToken != null ? "refresh_token=$refreshToken" : "",
        },
      ),
    );

    log("response DAta From API ${response.data}");

    return response.headers.map['set-cookie'] == null
        ? response.data
        : {
            "data": response.data,
            "cookies": response.headers.map['set-cookie'],
          };
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = preferences.getString("refreshToken");

      if (refreshToken == null) return false;

      final response = await _dio.post(
        '$_baseUrl/auth/refresh_token/',
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data['access'];

      if (newAccessToken != null) {
        await preferences.setString("accessToken", newAccessToken);
      }
      final cookies = response.headers['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        for (var cookie in cookies) {
          if (cookie.contains('refresh_token=')) {
            final newRefreshToken = cookie
                .split('refresh_token=')
                .last
                .split(';')
                .first
                .trim();
            await preferences.setString('refreshToken', newRefreshToken);
            break;
          }
        }
      }
      return newAccessToken != null;
    } catch (e) {
      log('Error refreshing token: $e');
      return false;
    }
  }

  Future<dynamic> get({
    String? token,
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    var response = await _dio.get(
      '$_baseUrl$endPoint',
      queryParameters: query,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": token != null ? "Bearer $token" : "",
        },
      ),
    );
    log("response.data GET ${response.data}");
    return response.data;
  }

  Future<Map<String, dynamic>> patch({
    String? token,
    required String endPoint,
    dynamic data,
    bool? isImage = false,
  }) async {
    var response = await _dio.patch(
      '$_baseUrl$endPoint',
      data: data,
      options: Options(
        headers: {
          "Content-Type": isImage == false
              ? "application/json"
              : "multipart/form-data",
          "Authorization": "Bearer $token",
        },
      ),
    );
    log("response.data patch ${response.data}");
    return response.data;
  }

  Future<dynamic> delete({String? token, required String endPoint}) async {
    var response = await _dio.delete(
      '$_baseUrl$endPoint',
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    log("response.data delete ${response.data}");
    return response.data;
  }

  Future<dynamic> put({
    String? token,
    required String endPoint,
    dynamic data,
    bool? isImage = false,
  }) async {
    var response = await _dio.put(
      '$_baseUrl$endPoint',
      data: data,
      options: Options(
        headers: {
          "Content-Type": isImage == false
              ? "application/json"
              : "multipart/form-data",
          "Authorization": token != null ? "Bearer $token" : "",
        },
      ),
    );

    return response.data;
  }

  // دالة تحميل الصورة من URL وحفظها مؤقتًا
  Future<File?> downloadImage(String url) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final tempDir = await getTemporaryDirectory();
      final fileName = url.split('/').last.split('?').first;
      final file = File('${tempDir.path}/temp_product_$fileName');

      // لو الملف موجود من قبل نحذفه
      if (await file.exists()) {
        await file.delete();
      }

      await file.writeAsBytes(response.data);
      return file;
    } catch (e) {
      log("Failed to download old image: $e");
      return null;
    }
  }
}
