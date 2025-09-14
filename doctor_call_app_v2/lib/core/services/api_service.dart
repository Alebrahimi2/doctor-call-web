import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  static const String baseUrl = 'http://localhost:8000/api';
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
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: ApiConfig.defaultHeaders,
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Request interceptor to add authentication token
    _dio.interceptors.add(InterceptorsWrapper(
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
    ));
    
    // Logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }
  
  // Generic GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
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
          return Exception('Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? 'Server error occurred';
          return Exception('Server error ($statusCode): $message');
        case DioExceptionType.cancel:
          return Exception('Request was cancelled');
        case DioExceptionType.connectionError:
          return Exception('No internet connection. Please check your network.');
        default:
          return Exception('An unexpected error occurred: ${error.message}');
      }
    }
    return Exception('An unexpected error occurred: $error');
  }
}