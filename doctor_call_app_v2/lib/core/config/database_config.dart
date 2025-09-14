class DatabaseConfig {
  static const String host = 'localhost';
  static const int port = 3306;
  static const String username = 'root';
  static const String password = '';
  static const String database = 'doctor_call_db';
  static const Duration timeout = Duration(seconds: 30);
  
  // إعدادات التطبيق
  static const String appName = 'Doctor Call App';
  static const String appVersion = '2.0.0';
  static const String environment = 'development';
  
  // إعدادات المصادقة
  static const String jwtSecret = 'doctor_call_jwt_secret_2024';
  static const Duration tokenExpiry = Duration(days: 7);
  
  // معلومات قاعدة البيانات
  static const String charset = 'utf8mb4';
  static const String collation = 'utf8mb4_unicode_ci';
  
  // إعدادات الاتصال
  static const bool autoReconnect = true;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  // الحصول على connection string
  static String get connectionString {
    return 'mysql://$username:$password@$host:$port/$database';
  }
  
  // معلومات الخادم
  static Map<String, dynamic> get serverInfo {
    return {
      'host': host,
      'port': port,
      'database': database,
      'charset': charset,
      'collation': collation,
      'environment': environment,
    };
  }
  
  // تحديد ما إذا كان في وضع الإنتاج
  static bool get isProduction => environment == 'production';
  
  // تحديد ما إذا كان في وضع التطوير
  static bool get isDevelopment => environment == 'development';
  
  // إعدادات XAMPP الافتراضية
  static const String xamppPath = 'C:/xampp';
  static const String defaultMysqlSocket = '/tmp/mysql.sock';
  
  // رسائل الخطأ
  static const Map<String, String> errorMessages = {
    'connection_failed': 'فشل في الاتصال بقاعدة البيانات',
    'database_not_found': 'قاعدة البيانات غير موجودة',
    'invalid_credentials': 'بيانات الاعتماد غير صحيحة',
    'timeout': 'انتهت مهلة الاتصال',
    'permission_denied': 'ليس لديك صلاحية للوصول',
  };
  
  // إعدادات الجداول
  static const Map<String, String> tables = {
    'users': 'users',
    'patients': 'patients', 
    'appointments': 'appointments',
    'medical_records': 'medical_records',
    'notifications': 'notifications',
  };
  
  // أعمدة جدول المستخدمين
  static const Map<String, String> userColumns = {
    'id': 'id',
    'name': 'name',
    'email': 'email',
    'password': 'password',
    'role': 'role',
    'phone': 'phone',
    'avatar': 'avatar',
    'department': 'department',
    'specialization': 'specialization',
    'profile_image': 'profile_image',
    'email_verified_at': 'email_verified_at',
    'created_at': 'created_at',
    'updated_at': 'updated_at',
    'token': 'token',
  };
  
  // الأدوار المسموحة
  static const List<String> allowedRoles = [
    'admin',
    'doctor', 
    'nurse',
    'patient'
  ];
  
  // المستخدمون الافتراضيون
  static const List<Map<String, dynamic>> defaultUsers = [
    {
      'name': 'مدير النظام',
      'email': 'admin@system.com',
      'password': 'admin2024',
      'role': 'admin',
      'phone': '+966501111111',
    },
    {
      'name': 'دكتور محمد العلي',
      'email': 'doctor@clinic.com', 
      'password': 'doctor2024',
      'role': 'doctor',
      'phone': '+966502222222',
      'department': 'General Medicine',
      'specialization': 'Internal Medicine',
    },
  ];
}