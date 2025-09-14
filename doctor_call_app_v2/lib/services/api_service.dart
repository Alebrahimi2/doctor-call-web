import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/hospital.dart';
import '../models/patient.dart';
import '../models/game_avatar.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  static const Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  String? _authToken;

  // تعيين التوكن
  void setAuthToken(String token) {
    _authToken = token;
  }

  // الحصول على الهيدر مع التوكن
  Map<String, String> get _headers {
    final headers = Map<String, String>.from(_baseHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // ============ Authentication API ============

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _baseHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        return data;
      } else {
        throw ApiException(
          response.statusCode,
          jsonDecode(response.body)['message'] ?? 'فشل في تسجيل الدخول',
        );
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _baseHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        return data;
      } else {
        throw ApiException(
          response.statusCode,
          jsonDecode(response.body)['message'] ?? 'فشل في التسجيل',
        );
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<void> logout() async {
    try {
      await http.post(Uri.parse('$baseUrl/logout'), headers: _headers);
      _authToken = null;
    } catch (e) {
      // تسجيل الخروج محلياً حتى لو فشل الطلب
      _authToken = null;
    }
  }

  // ============ User API ============

  Future<User> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب بيانات المستخدم');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<User> updateUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user'),
        headers: _headers,
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['user']);
      } else {
        throw ApiException(
          response.statusCode,
          jsonDecode(response.body)['message'] ?? 'فشل في تحديث البيانات',
        );
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  // ============ Hospital API ============

  Future<List<Hospital>> getHospitals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['hospitals'] as List)
            .map((json) => Hospital.fromJson(json))
            .toList();
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب المستشفيات');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<Hospital> getHospital(int hospitalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/$hospitalId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Hospital.fromJson(data['hospital']);
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب بيانات المستشفى');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<Hospital> createHospital(Map<String, dynamic> hospitalData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hospitals'),
        headers: _headers,
        body: jsonEncode(hospitalData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Hospital.fromJson(data['hospital']);
      } else {
        throw ApiException(
          response.statusCode,
          jsonDecode(response.body)['message'] ?? 'فشل في إنشاء المستشفى',
        );
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  // ============ Patient API ============

  Future<List<Patient>> getPatients({int? hospitalId}) async {
    try {
      String url = '$baseUrl/patients';
      if (hospitalId != null) {
        url += '?hospital_id=$hospitalId';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['patients'] as List)
            .map((json) => Patient.fromJson(json))
            .toList();
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب المرضى');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<Patient> getPatient(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Patient.fromJson(data['patient']);
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب بيانات المريض');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<Patient> updatePatientStatus(
    int patientId,
    PatientStatus status,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/patients/$patientId/status'),
        headers: _headers,
        body: jsonEncode({'status': status.toString().split('.').last}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Patient.fromJson(data['patient']);
      } else {
        throw ApiException(response.statusCode, 'فشل في تحديث حالة المريض');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  // ============ Avatar API ============

  Future<List<GameAvatar>> getAvatars({AvatarType? type}) async {
    try {
      String url = '$baseUrl/avatars';
      if (type != null) {
        url += '?type=${type.toString().split('.').last}';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['avatars'] as List)
            .map((json) => GameAvatar.fromJson(json))
            .toList();
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب الشخصيات');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<GameAvatar> updateAvatarStatus(
    int avatarId,
    Map<String, dynamic> status,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/avatars/$avatarId/status'),
        headers: _headers,
        body: jsonEncode(status),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GameAvatar.fromJson(data['avatar']);
      } else {
        throw ApiException(response.statusCode, 'فشل في تحديث حالة الشخصية');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  // ============ Game Statistics API ============

  Future<Map<String, dynamic>> getGameStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/stats'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب إحصائيات اللعبة');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  Future<Map<String, dynamic>> getHospitalStats(int hospitalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/$hospitalId/stats'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException(response.statusCode, 'فشل في جلب إحصائيات المستشفى');
      }
    } catch (e) {
      throw ApiException(500, 'خطأ في الاتصال: $e');
    }
  }

  // ============ Utility Methods ============

  // فحص الاتصال
  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'), headers: _baseHeaders)
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // مسح التوكن
  void clearAuth() {
    _authToken = null;
  }

  // فحص إذا كان المستخدم مسجل الدخول
  bool get isAuthenticated => _authToken != null;
}

// استثناء مخصص للـ API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

// Singleton instance
final ApiService apiService = ApiService();
