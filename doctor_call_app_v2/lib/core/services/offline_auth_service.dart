import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class OfflineAuthService {
  static final OfflineAuthService _instance = OfflineAuthService._internal();
  factory OfflineAuthService() => _instance;
  OfflineAuthService._internal();

  final ApiService _apiService = ApiService();

  // Login with email and password using Laravel API
  Future<AuthResult> login(String email, String password) async {
    try {
      // Authenticate user via Laravel API
      AuthResult result = await _apiService.login(email, password);
      
      if (result.isSuccess && result.user != null) {
        // Store token and user data locally for offline access
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result.token!);
        await prefs.setString('user_data', jsonEncode(result.user!.toJson()));
        await prefs.setBool('is_logged_in', true);
      }
      
      return result;
    } catch (e) {
      return AuthResult.failure('خطأ في تسجيل الدخول: $e');
    }
  }

  // Register new user using Laravel API
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? role,
    String? department,
    String? specialization,
  }) async {
    try {
      // Register user via Laravel API
      AuthResult result = await _apiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        role: role,
      );
      
      if (result.isSuccess && result.user != null) {
        // Store token and user data locally for offline access
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result.token!);
        await prefs.setString('user_data', jsonEncode(result.user!.toJson()));
        await prefs.setBool('is_logged_in', true);
      }
      
      return result;
    } catch (e) {
      return AuthResult.failure('خطأ في التسجيل: $e');
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      // Logout from Laravel API
      await _apiService.logout();
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      
      return true;
    } catch (e) {
      // Clear local storage even if API call fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      return true;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      if (token != null && token.isNotEmpty && isLoggedIn) {
        // Verify token with API
        _apiService.setAuthToken(token);
        return await _apiService.isTokenValid();
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  // Get current user from local storage or API
  Future<UserModel?> getCurrentUser() async {
    try {
      // Try to get from local storage first
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      
      if (userData != null) {
        final user = UserModel.fromJson(jsonDecode(userData));
        
        // Verify with API if online
        final apiUser = await _apiService.getCurrentUser();
        if (apiUser != null) {
          // Update local data with fresh API data
          await prefs.setString('user_data', jsonEncode(apiUser.toJson()));
          return apiUser;
        }
        
        return user; // Return cached data if API is unavailable
      }
      
      // If no local data, try API only
      final apiUser = await _apiService.getCurrentUser();
      if (apiUser != null) {
        await prefs.setString('user_data', jsonEncode(apiUser.toJson()));
      }
      
      return apiUser;
    } catch (e) {
      return null;
    }
  }

  // Test connection to Laravel API
  Future<Map<String, dynamic>> testConnection() async {
    return await _apiService.testConnection();
  }

  // Get database statistics from Laravel API
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      return await _apiService.getDatabaseStats();
    } catch (e) {
      return {
        'success': false,
        'error': 'خطأ في استرداد إحصائيات قاعدة البيانات: $e',
      };
    }
  }

  // Clear local authentication data
  Future<bool> clearLocalAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      await prefs.setBool('is_logged_in', false);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if we have offline authentication data
  Future<bool> hasOfflineAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userData = prefs.getString('user_data');
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      return token != null && userData != null && isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  // Get authentication token
  Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  // Set authentication token for API service
  Future<void> setApiToken() async {
    try {
      final token = await getAuthToken();
      if (token != null) {
        _apiService.setAuthToken(token);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Initialize authentication service
  Future<void> initialize() async {
    await setApiToken();
  }
}