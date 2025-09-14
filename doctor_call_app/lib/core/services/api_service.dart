import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // --- الإعدادات الأساسية ---
  // استخدم الرابط الكامل للـ backend API
  // ملاحظة: عند تشغيل التطبيق على جهاز حقيقي، استبدل 'localhost'
  // بـ IP address الخاص بجهاز الكمبيوتر الذي يشغل XAMPP.
  static const String _baseUrl =
      'http://localhost/games/Doctor_Call/fullstack-app/backend/public/api';

  // --- التوثيق (Authentication) ---
  // سيتم استخدام هذا التوكن في جميع الطلبات المحمية
  // سنقوم بتعيينه بعد تسجيل الدخول
  static String? _token;

  // دالة لتعيين التوكن بعد تسجيل الدخول
  static void setAuthToken(String token) {
    _token = token;
  }

  // دالة للحصول على Headers مع التوكن
  static Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // --- الخدمات (API Calls) ---

  /// لجلب إحصائيات لوحة التحكم
  Future<Map<String, dynamic>> getDashboardStats() async {
    // بناء الرابط الكامل
    final url = Uri.parse('$_baseUrl/dashboard/stats');

    try {
      // إرسال طلب GET
      final response = await http.get(url, headers: _getHeaders());

      // التحقق من نجاح الطلب
      if (response.statusCode == 200) {
        // تحويل الاستجابة من JSON إلى Map
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // خطأ في التوثيق (Unauthorized)
        throw Exception('خطأ في التوثيق: يرجى تسجيل الدخول مرة أخرى.');
      } else {
        // أي أخطاء أخرى من الخادم
        throw Exception('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      // أخطاء الشبكة أو مشاكل أخرى
      throw Exception('حدث خطأ في الشبكة: $e');
    }
  }

  // --- يمكنك إضافة دوال أخرى هنا ---
  // مثال:
  // Future<List<dynamic>> getPatients() async { ... }
  // Future<void> addDoctor(Map<String, dynamic> doctorData) async { ... }
}
