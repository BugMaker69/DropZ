/*
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';

  // حفظ الـ Token + استخراج البيانات
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    // فك الـ Token
    Map<String, dynamic> payload = Jwt.parseJwt(token);

    String? userId = payload['user_id']?.toString();
    String? role = payload['role']?.toString();

    if (userId != null) {
      await prefs.setString(_userIdKey, userId);
    }
    if (role != null) {
      await prefs.setString(_userRoleKey, role);
    }

    print("Saved User ID: $userId, Role: $role");
  }

  // جلب الـ Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // جلب الـ User ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // جلب الـ Role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // هل المستخدم بائع؟
  static Future<bool> isSeller() async {
    final role = await getUserRole();
    return role == 'seller';
  }

  // هل المستخدم عميل؟
  static Future<bool> isCustomer() async {
    final role = await getUserRole();
    return role == 'customer';
  }

  // تسجيل خروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userRoleKey);
    print("User logged out");
  }

  // هل المستخدم مسجل دخول؟
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && Jwt.isExpired(token) == false;
  }
}
*/
