import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // final _baseUrl = 'http://localhost:8000/api/';
  final _baseUrl = 'http://10.0.2.2:8000/api'; // For Emulator Phone
  // final _baseUrl = 'http://192.168.1.7:8000/api'; // For My Real Mobile Phone

  final Dio _dio;
  final SharedPreferences preferences;

  // ApiService(this._dio, this.preferences)

  /* ApiService(this._dio, this.preferences) {
  _dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = preferences.getString('accessToken');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        final statusCode = error.response?.statusCode;

        // إذا مش 401 نمرر الخطأ
        if (statusCode != 401) {
          return handler.next(error);
        }

        // تمنع محاولات متتالية من أخذ الـ refresh بنفس الوقت
        // تُقفل الـ dio وتمنع الطلبات الجديدة أثناء عملية الريفرش
        _dio.lock();
        _dio.interceptors.errorLock.lock();
        _dio.interceptors.requestLock.lock();

        try {
          final didRefresh = await _refreshToken(); // لازم تعرفها
          if (!didRefresh) {
            // فشل الريفرش -> أخرج المستخدم أو امسح التوكنات
            await _handleRefreshFailure();
            return handler.next(error);
          }

          // جلب الـ access token الجديد
          final newAccessToken = preferences.getString('accessToken');

          // نسخ RequestOptions الأصلي مع تعديل الهيدر
          final requestOptions = error.requestOptions;
          final opts = Options(
            method: requestOptions.method,
            headers: {
              ...?requestOptions.headers,
              'Authorization': 'Bearer $newAccessToken',
            },
            responseType: requestOptions.responseType,
            followRedirects: requestOptions.followRedirects,
            validateStatus: requestOptions.validateStatus,
            contentType: requestOptions.contentType,
          );

          // اعادة ارسال الطلب باستخدام fullUri لتجنب مشاكل baseUrl/path
          final uri = requestOptions.uri; // Uri
          final clonedResponse = await _dio.requestUri(
            uri,
            options: opts,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );

          return handler.resolve(clonedResponse);
        } catch (e) {
          return handler.next(error);
        } finally {
          // فك القفل دائماً
          _dio.unlock();
          _dio.interceptors.errorLock.unlock();
          _dio.interceptors.requestLock.unlock();
        }
      },
    ),
  );
}
*/

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
            final refreshed = await _refreshToken();

            if (refreshed) {
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
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    // required LoginRequest loginRequest,
    dynamic data,
    // Map<String, dynamic>? data,
    String? token,
    String? refreshToken,
    bool? isImage = false,
  }) async {
    /*_dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );*/
    var response = await _dio.post(
      '$_baseUrl$endPoint',
      data: data,
      // data: loginRequest,
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

    print("response DAta From API ${response.data}");

    return response.headers.map['set-cookie'] == null
        ? response.data
        : {
            "data": response.data,
            "cookies": response.headers.map['set-cookie'],
          };

    // return {
    //   "data": response.data,
    //   "cookies":
    //       response.headers.map['set-cookie'], // بترجع للـ Repo يتصرف بيها
    //   // "cookies": response.headers['set-cookie'], // بترجع للـ Repo يتصرف بيها
    // };

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

  /* Future<FormData> postFormData({
    required String endPoint,
    Map<String, dynamic>? data,
    String? token,
    String? refreshToken,
  }) async {
    var response = await _dio.post(
      '$_baseUrl$endPoint',
      data: data,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": token != null ? "Bearer $token" : "",
          "Cookie": refreshToken != null ? "refresh_token=$refreshToken" : "",
        },
      ),
    );

    print("response DAta From API ${response.data}");

    return response.headers.map['set-cookie'] == null
        ? response.data
        : {
            "data": response.data,
            "cookies": response.headers.map['set-cookie'],
          };

    // return {
    //   "data": response.data,
    //   "cookies":
    //       response.headers.map['set-cookie'], // بترجع للـ Repo يتصرف بيها
    //   // "cookies": response.headers['set-cookie'], // بترجع للـ Repo يتصرف بيها
    // };

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
*/

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
      print('Error refreshing token: $e');
      return false;
    }
  }

  // Future<Map<String, dynamic>> get({String? token, required String endPoint}) async {
  Future<dynamic> get({
    String? token,
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    /*_dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );*/
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
    print("response.data GET ${response.data}");
    return response.data;
  }

  Future<Map<String, dynamic>> patch({
    String? token,
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
    print("response.data patch ${response.data}");
    return response.data;
  }

  Future<dynamic> delete({String? token, required String endPoint}) async {
    /*_dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ),
    );*/
    var response = await _dio.delete(
      '$_baseUrl$endPoint',
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
    print("response.data delete ${response.data}");
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

          // if (isImage == false) "Content-Type": "application/json",
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
      print("Failed to download old image: $e");
      return null;
    }
  }
  // Future<File> downloadImage(String url) async {
  //   final response = await _dio.get(
  //     url,
  //     options: Options(responseType: ResponseType.bytes),
  //   );

  //   final tempDir = await getTemporaryDirectory();
  //   final fileName = url.split('/').last.split('?').first;
  //   final file = File('${tempDir.path}/temp_$fileName');
  //   await file.writeAsBytes(response.data);
  //   return file;
  // }
}
