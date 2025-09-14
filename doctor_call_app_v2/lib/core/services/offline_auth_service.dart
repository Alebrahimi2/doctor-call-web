import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class OfflineAuthService {
  static final OfflineAuthService _instance = OfflineAuthService._internal();
  factory OfflineAuthService() => _instance;
  OfflineAuthService._internal();

  final DatabaseService _databaseService = DatabaseService();

  // Login with email and password using MySQL database
  Future<AuthResult> login(String email, String password) async {
    try {
      // Connect to database
      bool connected = await _databaseService.connect();
      if (!connected) {
        return AuthResult.failure('فشل في الاتصال بقاعدة البيانات');
      }

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Authenticate user from MySQL database
      UserModel? user = await _databaseService.authenticateUser(email, password);
      
      if (user == null) {
        return AuthResult.failure('البريد الإلكتروني أو كلمة المرور غير صحيحة');
      }

      // Create token (fake JWT)
      final token = 'mysql_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

      // Update user token in database
      await _databaseService.updateUserToken(email, token);

      // Store token and user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      return AuthResult.success(user, token);
    } catch (e) {
      return AuthResult.failure('خطأ في تسجيل الدخول: $e');
    }
  }

  // Register new user in MySQL database
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
      // Connect to database
      bool connected = await _databaseService.connect();
      if (!connected) {
        return AuthResult.failure('فشل في الاتصال بقاعدة البيانات');
      }

      // Check if password matches confirmation
      if (password != passwordConfirmation) {
        return AuthResult.failure('كلمات المرور غير متطابقة');
      }

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Create user in MySQL database
      UserModel? user = await _databaseService.createUser(
        name: name,
        email: email,
        password: password,
        role: role ?? 'patient',
        phone: phone,
        department: department,
        specialization: specialization,
      );

      if (user == null) {
        return AuthResult.failure('فشل في إنشاء المستخدم');
      }

      // Create token
      final token = 'mysql_token_${user.id}_${DateTime.now().millisecondsSinceEpoch}';

      // Update user token in database
      await _databaseService.updateUserToken(email, token);

      // Store token and user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(user.toJson()));

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

  // Get current user from local storage
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        return UserModel.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get all users from MySQL database
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      bool connected = await _databaseService.connect();
      if (!connected) {
        return [];
      }
      return await _databaseService.getAllUsers();
    } catch (e) {
      print('خطأ في استرداد المستخدمين: $e');
      return [];
    }
  }

  // Clear all users from database (for testing)
  Future<bool> clearDatabase() async {
    try {
      bool connected = await _databaseService.connect();
      if (!connected) {
        return false;
      }
      return await _databaseService.clearAllUsers();
    } catch (e) {
      print('خطأ في مسح قاعدة البيانات: $e');
      return false;
    }
  }

  // Test database connection
  Future<Map<String, dynamic>> testConnection() async {
    return await _databaseService.testConnection();
  }

  // Reset database to default users
  Future<bool> resetToDefaults() async {
    try {
      bool cleared = await clearDatabase();
      if (cleared) {
        await Future.delayed(const Duration(milliseconds: 500));
        // Default users are automatically inserted by clearAllUsers method
        return true;
      }
      return false;
    } catch (e) {
      print('خطأ في إعادة تعيين قاعدة البيانات: $e');
      return false;
    }
  }

  // Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      bool connected = await _databaseService.connect();
      if (!connected) {
        return {'error': 'فشل في الاتصال بقاعدة البيانات'};
      }

      var users = await _databaseService.getAllUsers();
      var adminCount = users.where((u) => u['role'] == 'admin').length;
      var doctorCount = users.where((u) => u['role'] == 'doctor').length;
      var nurseCount = users.where((u) => u['role'] == 'nurse').length;
      var patientCount = users.where((u) => u['role'] == 'patient').length;

      return {
        'total': users.length,
        'admin': adminCount,
        'doctor': doctorCount,
        'nurse': nurseCount,
        'patient': patientCount,
        'users': users,
      };
    } catch (e) {
      return {'error': 'خطأ في استرداد إحصائيات قاعدة البيانات: $e'};
    }
  }
}