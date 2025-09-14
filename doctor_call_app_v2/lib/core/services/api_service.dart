import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../config/database_config.dart';

class ApiConfig {
  static const String baseUrl = 'https://flutterhelper.com/api';
  static const Duration timeout = Duration(seconds: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
}

class ApiService {
  late Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.timeout,
        receiveTimeout: ApiConfig.timeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor to add authentication token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired, clear storage and redirect to login
            await _storage.delete(key: 'auth_token');
            await _storage.delete(key: 'user_data');
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor for debugging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  // Generic GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParameters);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<Response> delete(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Store authentication token
  Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Clear authentication data
  Future<void> clearAuth() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_data');
  }

  // Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception(
            'Connection timeout. Please check your internet connection.',
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message =
              error.response?.data?['message'] ?? 'Server error occurred';
          return Exception('Server error ($statusCode): $message');
        case DioExceptionType.cancel:
          return Exception('Request was cancelled');
        case DioExceptionType.connectionError:
          return Exception(
            'No internet connection. Please check your network.',
          );
        default:
          return Exception('An unexpected error occurred: ${error.message}');
      }
    }
    return Exception('An unexpected error occurred: $error');
  }

  // Authentication methods for Laravel API
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['data']['token'];
        final user = UserModel.fromJson(response.data['data']['user']);

        await storeToken(token);
        await _storage.write(key: 'user_data', value: user.toJson().toString());

        return AuthResult.success(user, token);
      } else {
        return AuthResult.failure(
          response.data['message'] ?? 'فشل في تسجيل الدخول',
        );
      }
    } catch (e) {
      return AuthResult.failure('خطأ في الاتصال بالخادم: $e');
    }
  }

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? role,
  }) async {
    try {
      final response = await post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
          'role': role ?? 'patient',
        },
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final token = response.data['data']['token'];
        final user = UserModel.fromJson(response.data['data']['user']);

        await storeToken(token);
        await _storage.write(key: 'user_data', value: user.toJson().toString());

        return AuthResult.success(user, token);
      } else {
        return AuthResult.failure(response.data['message'] ?? 'فشل في التسجيل');
      }
    } catch (e) {
      return AuthResult.failure('خطأ في الاتصال بالخادم: $e');
    }
  }

  Future<bool> logout() async {
    try {
      await post('/auth/logout');
      await clearAuth();
      return true;
    } catch (e) {
      await clearAuth();
      return true; // Clear local auth even if server request fails
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await get('/auth/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await get('/dashboard/stats');
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'تم الاتصال بـ Laravel API بنجاح',
          'api_url': ApiConfig.baseUrl,
          'database': 'hospital_sim',
          'stats': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'فشل في الاتصال بـ Laravel API',
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم',
        'error': e.toString(),
        'api_url': ApiConfig.baseUrl,
      };
    }
  }

  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final response = await get('/dashboard/stats');
      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'success': true,
          'total': (data['users'] ?? 0) + (data['staff'] ?? 0),
          'users': data['users'] ?? 0,
          'staff': data['staff'] ?? 0,
          'patients': data['patients'] ?? 0,
          'departments': data['departments'] ?? 0,
          'missions': data['missions'] ?? 0,
          'kpis': data['kpis'] ?? 0,
        };
      } else {
        return {'success': false, 'error': 'فشل في الحصول على الإحصائيات'};
      }
    } catch (e) {
      return {'success': false, 'error': 'خطأ في الاتصال: $e'};
    }
  }
}

// Authentication result helper class
class AuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? token;
  final String? error;

  AuthResult._({required this.isSuccess, this.user, this.token, this.error});

  factory AuthResult.success(UserModel user, String token) {
    return AuthResult._(isSuccess: true, user: user, token: token);
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(isSuccess: false, error: error);
  }
}
