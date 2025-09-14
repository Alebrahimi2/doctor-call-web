import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/hospital.dart';
import '../models/patient.dart';
import '../models/game_avatar.dart';

class DioApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  late final Dio _dio;

  DioApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // إضافة Interceptors للتعامل مع الأخطاء والتوكن
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // إضافة التوكن تلقائياً إذا كان متوفراً
          final token = _getStoredToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('🚀 ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ${error.response?.statusCode} ${error.requestOptions.path}');
          print('Error: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
    _saveTokenToStorage(token);
  }

  String? _getStoredToken() {
    // هنا يمكنك إضافة منطق لحفظ/جلب التوكن من SharedPreferences
    return _authToken;
  }

  void _saveTokenToStorage(String token) {
    // هنا يمكنك إضافة منطق لحفظ التوكن في SharedPreferences
    _authToken = token;
  }

  void clearAuth() {
    _authToken = null;
    // مسح التوكن من التخزين المحلي
  }

  bool get isAuthenticated => _authToken != null;

  // ============ Authentication API ============

  Future<ApiResponse<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      if (response.data['token'] != null) {
        setAuthToken(response.data['token']);
      }

      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
        },
      );

      if (response.data['token'] != null) {
        setAuthToken(response.data['token']);
      }

      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      await _dio.post('/logout');
      clearAuth();
      return ApiResponse.success(null);
    } on DioException catch (e) {
      clearAuth(); // مسح التوكن محلياً حتى لو فشل الطلب
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ User API ============

  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final response = await _dio.get('/user');
      final user = User.fromJson(response.data['user']);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<User>> updateUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.put('/user', data: userData);
      final user = User.fromJson(response.data['user']);
      return ApiResponse.success(user);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ Hospital API ============

  Future<ApiResponse<List<Hospital>>> getHospitals() async {
    try {
      final response = await _dio.get('/hospitals');
      final hospitals = (response.data['hospitals'] as List)
          .map((json) => Hospital.fromJson(json))
          .toList();
      return ApiResponse.success(hospitals);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Hospital>> getHospital(int hospitalId) async {
    try {
      final response = await _dio.get('/hospitals/$hospitalId');
      final hospital = Hospital.fromJson(response.data['hospital']);
      return ApiResponse.success(hospital);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Hospital>> createHospital(
    Map<String, dynamic> hospitalData,
  ) async {
    try {
      final response = await _dio.post('/hospitals', data: hospitalData);
      final hospital = Hospital.fromJson(response.data['hospital']);
      return ApiResponse.success(hospital);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Hospital>> updateHospital(
    int hospitalId,
    Map<String, dynamic> hospitalData,
  ) async {
    try {
      final response = await _dio.put(
        '/hospitals/$hospitalId',
        data: hospitalData,
      );
      final hospital = Hospital.fromJson(response.data['hospital']);
      return ApiResponse.success(hospital);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ Patient API ============

  Future<ApiResponse<List<Patient>>> getPatients({
    int? hospitalId,
    PatientStatus? status,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (hospitalId != null) queryParams['hospital_id'] = hospitalId;
      if (status != null)
        queryParams['status'] = status.toString().split('.').last;

      final response = await _dio.get(
        '/patients',
        queryParameters: queryParams,
      );
      final patients = (response.data['patients'] as List)
          .map((json) => Patient.fromJson(json))
          .toList();
      return ApiResponse.success(patients);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Patient>> getPatient(int patientId) async {
    try {
      final response = await _dio.get('/patients/$patientId');
      final patient = Patient.fromJson(response.data['patient']);
      return ApiResponse.success(patient);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Patient>> updatePatientStatus(
    int patientId,
    PatientStatus status,
  ) async {
    try {
      final response = await _dio.put(
        '/patients/$patientId/status',
        data: {'status': status.toString().split('.').last},
      );
      final patient = Patient.fromJson(response.data['patient']);
      return ApiResponse.success(patient);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Patient>> createPatient(
    Map<String, dynamic> patientData,
  ) async {
    try {
      final response = await _dio.post('/patients', data: patientData);
      final patient = Patient.fromJson(response.data['patient']);
      return ApiResponse.success(patient);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ Avatar API ============

  Future<ApiResponse<List<GameAvatar>>> getAvatars({
    AvatarType? type,
    int? hospitalId,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (type != null) queryParams['type'] = type.toString().split('.').last;
      if (hospitalId != null) queryParams['hospital_id'] = hospitalId;

      final response = await _dio.get('/avatars', queryParameters: queryParams);
      final avatars = (response.data['avatars'] as List)
          .map((json) => GameAvatar.fromJson(json))
          .toList();
      return ApiResponse.success(avatars);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<GameAvatar>> getAvatar(int avatarId) async {
    try {
      final response = await _dio.get('/avatars/$avatarId');
      final avatar = GameAvatar.fromJson(response.data['avatar']);
      return ApiResponse.success(avatar);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<GameAvatar>> updateAvatarStatus(
    int avatarId,
    Map<String, dynamic> status,
  ) async {
    try {
      final response = await _dio.put(
        '/avatars/$avatarId/status',
        data: status,
      );
      final avatar = GameAvatar.fromJson(response.data['avatar']);
      return ApiResponse.success(avatar);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ Game Statistics API ============

  Future<ApiResponse<Map<String, dynamic>>> getGameStats() async {
    try {
      final response = await _dio.get('/game/stats');
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getHospitalStats(
    int hospitalId,
  ) async {
    try {
      final response = await _dio.get('/hospitals/$hospitalId/stats');
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    try {
      final response = await _dio.get('/user/stats');
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ Real-time Updates API ============

  Future<ApiResponse<List<Patient>>> getRealtimePatients(int hospitalId) async {
    try {
      final response = await _dio.get(
        '/hospitals/$hospitalId/patients/realtime',
      );
      final patients = (response.data['patients'] as List)
          .map((json) => Patient.fromJson(json))
          .toList();
      return ApiResponse.success(patients);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getRealtimeHospitalStatus(
    int hospitalId,
  ) async {
    try {
      final response = await _dio.get('/hospitals/$hospitalId/realtime');
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    }
  }

  // ============ Utility Methods ============

  Future<bool> checkConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.sendTimeout:
        return 'انتهت مهلة الإرسال';
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاستقبال';
      case DioExceptionType.badResponse:
        if (error.response?.data != null &&
            error.response?.data['message'] != null) {
          return error.response!.data['message'];
        }
        return 'خطأ في الخادم (${error.response?.statusCode})';
      case DioExceptionType.cancel:
        return 'تم إلغاء الطلب';
      case DioExceptionType.connectionError:
        return 'خطأ في الاتصال بالإنترنت';
      default:
        return 'خطأ غير معروف: ${error.message}';
    }
  }
}

// كلاس لتغليف الاستجابة
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse.success(this.data) : success = true, error = null;
  ApiResponse.error(this.error) : success = false, data = null;
}

// Singleton instance للاستخدام السهل
final DioApiService dioApiService = DioApiService();
