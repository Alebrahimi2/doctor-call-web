import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'offline_auth_service.dart';

class AuthService {
  final OfflineAuthService _offlineService = OfflineAuthService();

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      // Use offline service for demo/development
      return await _offlineService.login(email, password);
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
      // Use offline service for demo/development
      return await _offlineService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        role: role,
      );
    } catch (e) {
      return AuthResult.failure('خطأ في التسجيل: $e');
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      return await _offlineService.logout();
    } catch (e) {
      return false;
    }
  }

  // Get current user info
  Future<UserModel?> getCurrentUser() async {
    try {
      return await _offlineService.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      return await _offlineService.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  // Get stored user data
  Future<UserModel?> getStoredUser() async {
    try {
      return await _offlineService.getStoredUser();
    } catch (e) {
      return null;
    }
  }

  // Clear authentication data
  Future<void> clearAuth() async {
    try {
      await _offlineService.clearAuth();
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
