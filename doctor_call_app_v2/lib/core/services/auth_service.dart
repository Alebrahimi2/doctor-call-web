import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  // Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final userData = data['user'];
        
        // Store token and user data
        await _apiService.storeToken(token);
        await _storage.write(key: 'user_data', value: jsonEncode(userData));
        
        final user = UserModel.fromJson(userData);
        return AuthResult.success(user, token);
      }
      
      return AuthResult.failure(response.data['message'] ?? 'Login failed');
    } catch (e) {
      return AuthResult.failure(e.toString());
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
      final response = await _apiService.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        if (phone != null) 'phone': phone,
        if (role != null) 'role': role,
      });
      
      if (response.statusCode == 201) {
        final data = response.data;
        final token = data['token'];
        final userData = data['user'];
        
        // Store token and user data
        await _apiService.storeToken(token);
        await _storage.write(key: 'user_data', value: jsonEncode(userData));
        
        final user = UserModel.fromJson(userData);
        return AuthResult.success(user, token);
      }
      
      return AuthResult.failure(response.data['message'] ?? 'Registration failed');
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }
  
  // Logout user
  Future<bool> logout() async {
    try {
      await _apiService.post('/auth/logout');
      await _apiService.clearAuth();
      return true;
    } catch (e) {
      // Even if logout request fails, clear local data
      await _apiService.clearAuth();
      return false;
    }
  }
  
  // Get current user info
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _apiService.get('/auth/user');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _apiService.getToken();
    if (token == null) return false;
    
    try {
      final response = await _apiService.get('/auth/check');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // Get stored user data
  Future<UserModel?> getStoredUser() async {
    try {
      final userDataString = await _storage.read(key: 'user_data');
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final response = await _apiService.post('/auth/refresh');
      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await _apiService.storeToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
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
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (avatar != null) data['avatar'] = avatar;
      
      final response = await _apiService.put('/auth/profile', data: data);
      
      if (response.statusCode == 200) {
        final userData = response.data['user'];
        await _storage.write(key: 'user_data', value: jsonEncode(userData));
        
        final user = UserModel.fromJson(userData);
        return AuthResult.success(user);
      }
      
      return AuthResult.failure(response.data['message'] ?? 'Update failed');
    } catch (e) {
      return AuthResult.failure(e.toString());
    }
  }
  
  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.put('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': passwordConfirmation,
      });
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// Authentication result class
class AuthResult {
  final bool success;
  final String? error;
  final UserModel? user;
  final String? token;
  
  AuthResult.success(this.user, [this.token]) : success = true, error = null;
  AuthResult.failure(this.error) : success = false, user = null, token = null;
}