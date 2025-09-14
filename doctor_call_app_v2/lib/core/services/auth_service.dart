import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // SharedPreferences keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Mock authentication - check for demo credentials
      if (email.isNotEmpty && password.isNotEmpty) {
        // Create a mock user
        final user = UserModel(
          id: '1',
          name: 'Demo User',
          email: email,
          phone: '123456789',
          role: 'patient',
          avatar: null,
        );

        // Store token and user data
        await prefs.setString(
          _tokenKey,
          'demo_token_${DateTime.now().millisecondsSinceEpoch}',
        );
        await prefs.setString(_userKey, jsonEncode(user.toJson()));

        return AuthResult.success(user, 'demo_token');
      }

      return AuthResult.failure('البيانات غير صحيحة');
    } catch (e) {
      return AuthResult.failure('خطأ في تسجيل الدخول: $e');
    }
  }

  // Register new user
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? role,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Basic validation
      if (password != passwordConfirmation) {
        return AuthResult.failure('كلمة المرور غير متطابقة');
      }

      // Create a mock user
      final user = UserModel(
        id: '2',
        name: name,
        email: email,
        phone: phone ?? '',
        role: role ?? 'patient',
        avatar: null,
      );

      // Store token and user data
      await prefs.setString(
        _tokenKey,
        'demo_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await prefs.setString(_userKey, jsonEncode(user.toJson()));

      return AuthResult.success(user, 'demo_token');
    } catch (e) {
      return AuthResult.failure('خطأ في التسجيل: $e');
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current user info
  Future<UserModel?> getCurrentUser() async {
    try {
      return await getStoredUser();
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey) != null;
    } catch (e) {
      return false;
    }
  }

  // Get stored user data
  Future<UserModel?> getStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      if (userData != null) {
        final Map<String, dynamic> userMap = jsonDecode(userData);
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Clear authentication data
  Future<void> clearAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      // Ignore errors in clearing
    }
  }

  // Update user profile
  Future<AuthResult> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) async {
    try {
      // For now, just return success (implement later)
      final user = await getCurrentUser();
      if (user != null) {
        return AuthResult.success(user, '');
      }
      return AuthResult.failure('المستخدم غير موجود');
    } catch (e) {
      return AuthResult.failure('خطأ في تحديث الملف الشخصي: $e');
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      // For now, just return true (implement later)
      return true;
    } catch (e) {
      return false;
    }
  }
}
