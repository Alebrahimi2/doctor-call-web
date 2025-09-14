import 'dart:async';
import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  MySqlConnection? _connection;
  bool _isConnected = false;

  // إعدادات الاتصال بقاعدة البيانات
  final ConnectionSettings _settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: '',
    db: 'doctor_call_db',
    timeout: Duration(seconds: 30),
  );

  // الاتصال بقاعدة البيانات
  Future<bool> connect() async {
    try {
      if (_isConnected && _connection != null) {
        return true;
      }

      _connection = await MySqlConnection.connect(_settings);
      _isConnected = true;
      
      // إنشاء الجداول إذا لم تكن موجودة
      await _createTables();
      
      print('✅ تم الاتصال بقاعدة البيانات MySQL بنجاح');
      return true;
    } catch (e) {
      print('❌ خطأ في الاتصال بقاعدة البيانات: $e');
      _isConnected = false;
      return false;
    }
  }

  // قطع الاتصال
  Future<void> disconnect() async {
    try {
      if (_connection != null) {
        await _connection!.close();
        _connection = null;
        _isConnected = false;
        print('تم قطع الاتصال بقاعدة البيانات');
      }
    } catch (e) {
      print('خطأ في قطع الاتصال: $e');
    }
  }

  // التحقق من حالة الاتصال
  bool get isConnected => _isConnected && _connection != null;

  // إنشاء الجداول المطلوبة
  Future<void> _createTables() async {
    if (!isConnected) return;

    try {
      // جدول المستخدمين
      await _connection!.query('''
        CREATE TABLE IF NOT EXISTS users (
          id INT AUTO_INCREMENT PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          email VARCHAR(255) UNIQUE NOT NULL,
          password VARCHAR(255) NOT NULL,
          role ENUM('admin', 'doctor', 'nurse', 'patient') DEFAULT 'patient',
          phone VARCHAR(20),
          avatar TEXT,
          department VARCHAR(100),
          specialization VARCHAR(100),
          profile_image TEXT,
          email_verified_at TIMESTAMP NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          token TEXT
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
      ''');

      // جدول المرضى
      await _connection!.query('''
        CREATE TABLE IF NOT EXISTS patients (
          id INT AUTO_INCREMENT PRIMARY KEY,
          user_id INT,
          medical_history TEXT,
          allergies TEXT,
          emergency_contact VARCHAR(20),
          insurance_info TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
      ''');

      // جدول المواعيد
      await _connection!.query('''
        CREATE TABLE IF NOT EXISTS appointments (
          id INT AUTO_INCREMENT PRIMARY KEY,
          patient_id INT,
          doctor_id INT,
          appointment_date DATETIME NOT NULL,
          status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
          notes TEXT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
          FOREIGN KEY (doctor_id) REFERENCES users(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
      ''');

      // إدراج البيانات الافتراضية
      await _insertDefaultUsers();

      print('✅ تم إنشاء الجداول بنجاح');
    } catch (e) {
      print('❌ خطأ في إنشاء الجداول: $e');
    }
  }

  // إدراج المستخدمين الافتراضيين
  Future<void> _insertDefaultUsers() async {
    try {
      // التحقق من وجود مستخدمين
      var result = await _connection!.query('SELECT COUNT(*) as count FROM users');
      var count = result.first['count'];
      
      if (count == 0) {
        // إدراج المستخدمين الافتراضيين
        await _connection!.query('''
          INSERT INTO users (name, email, password, role, phone, created_at) VALUES
          ('مدير النظام', 'admin@system.com', 'admin2024', 'admin', '+966501111111', NOW()),
          ('دكتور محمد العلي', 'doctor@clinic.com', 'doctor2024', 'doctor', '+966502222222', NOW())
        ''');
        
        print('✅ تم إدراج المستخدمين الافتراضيين');
      }
    } catch (e) {
      print('❌ خطأ في إدراج البيانات الافتراضية: $e');
    }
  }

  // البحث عن مستخدم بالبريد الإلكتروني وكلمة المرور
  Future<UserModel?> authenticateUser(String email, String password) async {
    if (!isConnected) {
      await connect();
    }

    try {
      var result = await _connection!.query(
        'SELECT * FROM users WHERE email = ? AND password = ?',
        [email, password]
      );

      if (result.isNotEmpty) {
        var row = result.first;
        return UserModel(
          id: row['id'].toString(),
          name: row['name'],
          email: row['email'],
          role: row['role'],
          phone: row['phone'],
          avatar: row['avatar'],
          department: row['department'],
          specialization: row['specialization'],
          profileImage: row['profile_image'],
          emailVerifiedAt: row['email_verified_at']?.toString(),
          createdAt: row['created_at']?.toString(),
          updatedAt: row['updated_at']?.toString(),
          token: row['token'],
        );
      }
      return null;
    } catch (e) {
      print('❌ خطأ في المصادقة: $e');
      return null;
    }
  }

  // إنشاء مستخدم جديد
  Future<UserModel?> createUser({
    required String name,
    required String email,
    required String password,
    String role = 'patient',
    String? phone,
    String? department,
    String? specialization,
  }) async {
    if (!isConnected) {
      await connect();
    }

    try {
      // التحقق من عدم وجود البريد الإلكتروني
      var existing = await _connection!.query(
        'SELECT id FROM users WHERE email = ?',
        [email]
      );

      if (existing.isNotEmpty) {
        throw Exception('البريد الإلكتروني مستخدم بالفعل');
      }

      // إدراج المستخدم الجديد
      var result = await _connection!.query('''
        INSERT INTO users (name, email, password, role, phone, department, specialization, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
      ''', [name, email, password, role, phone, department, specialization]);

      // استرداد المستخدم المُدرج
      var insertedId = result.insertId;
      var userResult = await _connection!.query(
        'SELECT * FROM users WHERE id = ?',
        [insertedId]
      );

      if (userResult.isNotEmpty) {
        var row = userResult.first;
        return UserModel(
          id: row['id'].toString(),
          name: row['name'],
          email: row['email'],
          role: row['role'],
          phone: row['phone'],
          avatar: row['avatar'],
          department: row['department'],
          specialization: row['specialization'],
          profileImage: row['profile_image'],
          emailVerifiedAt: row['email_verified_at']?.toString(),
          createdAt: row['created_at']?.toString(),
          updatedAt: row['updated_at']?.toString(),
          token: row['token'],
        );
      }
      return null;
    } catch (e) {
      print('❌ خطأ في إنشاء المستخدم: $e');
      throw e;
    }
  }

  // الحصول على جميع المستخدمين
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    if (!isConnected) {
      await connect();
    }

    try {
      var result = await _connection!.query('SELECT * FROM users ORDER BY created_at DESC');
      
      return result.map((row) => {
        'id': row['id'],
        'name': row['name'],
        'email': row['email'],
        'role': row['role'],
        'phone': row['phone'],
        'department': row['department'],
        'specialization': row['specialization'],
        'created_at': row['created_at']?.toString(),
        'updated_at': row['updated_at']?.toString(),
      }).toList();
    } catch (e) {
      print('❌ خطأ في استرداد المستخدمين: $e');
      return [];
    }
  }

  // حذف جميع المستخدمين (للاختبار)
  Future<bool> clearAllUsers() async {
    if (!isConnected) {
      await connect();
    }

    try {
      await _connection!.query('DELETE FROM users');
      await _insertDefaultUsers(); // إعادة إدراج المستخدمين الافتراضيين
      return true;
    } catch (e) {
      print('❌ خطأ في حذف المستخدمين: $e');
      return false;
    }
  }

  // تحديث token المستخدم
  Future<bool> updateUserToken(String email, String token) async {
    if (!isConnected) {
      await connect();
    }

    try {
      await _connection!.query(
        'UPDATE users SET token = ? WHERE email = ?',
        [token, email]
      );
      return true;
    } catch (e) {
      print('❌ خطأ في تحديث التوكن: $e');
      return false;
    }
  }

  // اختبار الاتصال
  Future<Map<String, dynamic>> testConnection() async {
    try {
      bool connected = await connect();
      if (!connected) {
        return {
          'success': false,
          'message': 'فشل في الاتصال بقاعدة البيانات',
          'details': 'تأكد من تشغيل MySQL وصحة إعدادات الاتصال'
        };
      }

      var result = await _connection!.query('SELECT VERSION() as version');
      var version = result.first['version'];

      var userCount = await _connection!.query('SELECT COUNT(*) as count FROM users');
      var count = userCount.first['count'];

      return {
        'success': true,
        'message': 'تم الاتصال بقاعدة البيانات بنجاح',
        'version': version,
        'userCount': count,
        'database': 'doctor_call_db',
        'host': 'localhost:3306'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'خطأ في اختبار الاتصال',
        'error': e.toString()
      };
    }
  }
}