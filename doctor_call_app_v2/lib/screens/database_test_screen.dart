import 'package:flutter/material.dart';
import '../core/services/offline_auth_service.dart';

class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen> {
  final OfflineAuthService _authService = OfflineAuthService();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _authService.getAllUsers();
      setState(() {
        _users = users;
        _message = 'تم تحميل ${users.length} مستخدم';
      });
    } catch (e) {
      setState(() {
        _message = 'خطأ في تحميل المستخدمين: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.clearAllData();
      await _loadUsers();
      setState(() {
        _message = 'تم مسح جميع البيانات وإعادة التعيين';
      });
    } catch (e) {
      setState(() {
        _message = 'خطأ في مسح البيانات: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _authService.login(email, password);
      setState(() {
        _message = result.success 
            ? 'تسجيل دخول ناجح للمستخدم: ${result.user?.name}'
            : 'فشل تسجيل الدخول: ${result.error}';
      });
    } catch (e) {
      setState(() {
        _message = 'خطأ في اختبار تسجيل الدخول: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار قاعدة البيانات'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Message
            if (_message.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _message.contains('خطأ') 
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  border: Border.all(
                    color: _message.contains('خطأ') 
                        ? Colors.red 
                        : Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('خطأ') 
                        ? Colors.red 
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Control Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loadUsers,
                    icon: const Icon(Icons.refresh),
                    label: const Text('تحديث المستخدمين'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _clearDatabase,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('مسح البيانات'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),

            // Test Login Buttons
            const Text(
              'اختبار تسجيل الدخول:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading 
                        ? null 
                        : () => _testLogin('admin@system.com', 'admin2024'),
                    child: const Text('اختبار المدير'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading 
                        ? null 
                        : () => _testLogin('doctor@clinic.com', 'doctor2024'),
                    child: const Text('اختبار الطبيب'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Users List
            const Text(
              'المستخدمين المتاحين:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // Users List
            if (!_isLoading)
              Expanded(
                child: _users.isEmpty
                    ? const Center(
                        child: Text('لا توجد مستخدمين'),
                      )
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: user['role'] == 'admin' 
                                    ? Colors.red 
                                    : Colors.blue,
                                child: Icon(
                                  user['role'] == 'admin' 
                                      ? Icons.admin_panel_settings
                                      : Icons.local_hospital,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(user['name'] ?? 'مجهول'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('البريد: ${user['email'] ?? 'غير محدد'}'),
                                  Text('الدور: ${user['role'] ?? 'غير محدد'}'),
                                  Text('الهاتف: ${user['phone'] ?? 'غير محدد'}'),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(user['role'] ?? 'غير محدد'),
                                backgroundColor: user['role'] == 'admin' 
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : Colors.blue.withValues(alpha: 0.1),
                              ),
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}