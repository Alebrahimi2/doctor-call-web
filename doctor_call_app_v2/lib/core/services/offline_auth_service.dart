import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class OfflineAuthService {
  static final OfflineAuthService _instance = OfflineAuthService._internal();
  factory OfflineAuthService() => _instance;
  OfflineAuthService._internal();

  // Default demo users
  final List<Map<String, dynamic>> _demoUsers = [
    {
      'id': '1',
      'name': 'دكتور أحمد محمد',
      'email': 'doctor@hospital.com',
      'password': '123456',
      'role': 'doctor',
      'phone': '+966501234567',
      'department': 'Cardiology',
      'specialization': 'Heart Surgery',
      'profile_image': null,
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'name': 'إدارة المستشفى',
      'email': 'admin@hospital.com',
      'password': 'admin123',
      'role': 'admin',
      'phone': '+966501234568',
      'department': 'Administration',
      'specialization': 'Hospital Management',
      'profile_image': null,
      'created_at': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'name': 'ممرضة فاطمة',
      'email': 'nurse@hospital.com',
      'password': 'nurse123',
      'role': 'nurse',
      'phone': '+966501234569',
      'department': 'Emergency',
      'specialization': 'Emergency Care',
      'profile_image': null,
      'created_at': DateTime.now().toIso8601String(),
    },
  ];

  // Login with email and password
  Future<AuthResult> login(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Find user in demo data
      final userData = _demoUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (userData.isEmpty) {
        return AuthResult.failure('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }

      // Create token (fake JWT)
      final token = 'demo_token_${userData['id']}_${DateTime.now().millisecondsSinceEpoch}';

      // Store token and user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(userData));

      final user = UserModel.fromJson(userData);
      return AuthResult.success(user, token);
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if password matches confirmation
      if (password != passwordConfirmation) {
        return AuthResult.failure('كلمات المرور غير متطابقة');
      }

      // Check if email already exists
      final existingUser = _demoUsers.any((user) => user['email'] == email);
      if (existingUser) {
        return AuthResult.failure('البريد الإلكتروني مستخدم بالفعل');
      }

      // Create new user
      final newUserId = (_demoUsers.length + 1).toString();
      final userData = {
        'id': newUserId,
        'name': name,
        'email': email,
        'role': role ?? 'patient',
        'phone': phone,
        'department': role == 'doctor' ? 'General' : null,
        'specialization': role == 'doctor' ? 'General Practice' : null,
        'profile_image': null,
        'created_at': DateTime.now().toIso8601String(),
      };

      // Add to demo users list (for this session only)
      _demoUsers.add(userData..addAll({'password': password}));

      // Create token
      final token = 'demo_token_${userData['id']}_${DateTime.now().millisecondsSinceEpoch}';

      // Store token and user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(userData));

      final user = UserModel.fromJson(userData);
      return AuthResult.success(user, token);
    } catch (e) {
      return AuthResult.failure('خطأ في التسجيل: $e');
    }
  }

  // Logout user
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Get current user from storage
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final Map<String, dynamic> userJson = jsonDecode(userData);
        return UserModel.fromJson(userJson);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get stored user data
  Future<UserModel?> getStoredUser() async {
    return await getCurrentUser();
  }

  // Clear authentication data
  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  // Get demo users (for testing purposes)
  List<Map<String, dynamic>> getDemoUsers() {
    return _demoUsers.map((user) {
      final userCopy = Map<String, dynamic>.from(user);
      userCopy.remove('password'); // Don't expose passwords
      return userCopy;
    }).toList();
  }
}

// AuthResult class for consistent return type
class AuthResult {
  final bool success;
  final UserModel? user;
  final String? token;
  final String? error;

  AuthResult._({
    required this.success,
    this.user,
    this.token,
    this.error,
  });

  factory AuthResult.success(UserModel user, String token) {
    return AuthResult._(
      success: true,
      user: user,
      token: token,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(
      success: false,
      error: error,
    );
  }
}