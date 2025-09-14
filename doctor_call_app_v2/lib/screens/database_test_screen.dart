import 'package:flutter/material.dart';
import '../core/services/offline_auth_service.dart';
import '../core/config/database_config.dart';

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
  Map<String, dynamic>? _connectionStatus;
  Map<String, dynamic>? _dbStats;

  @override
  void initState() {
    super.initState();
    _testConnection();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _message = 'جاري اختبار الاتصال بقاعدة البيانات...';
    });

    try {
      final result = await _authService.testConnection();
      setState(() {
        _connectionStatus = result;
        if (result['success'] == true) {
          _message = '✅ ${result['message']}';
          _loadUsers();
          _loadStats();
        } else {
          _message = '❌ ${result['message']}';
        }
      });
    } catch (e) {
      setState(() {
        _message = 'خطأ في اختبار الاتصال: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _authService.getAllUsers();
      setState(() {
        _users = users;
        _message = 'تم تحميل ${users.length} مستخدم من MySQL';
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

  Future<void> _loadStats() async {
    try {
      final stats = await _authService.getDatabaseStats();
      setState(() {
        _dbStats = stats;
      });
    } catch (e) {
      print('خطأ في تحميل الإحصائيات: $e');
    }
  }

  Future<void> _clearDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.clearDatabase();
      if (success) {
        setState(() {
          _message = '✅ تم مسح قاعدة البيانات وإعادة تعيين المستخدمين الافتراضيين';
        });
        await _loadUsers();
        await _loadStats();
      } else {
        setState(() {
          _message = '❌ فشل في مسح قاعدة البيانات';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'خطأ في مسح قاعدة البيانات: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
      _message = 'جاري اختبار تسجيل الدخول...';
    });

    try {
      final result = await _authService.login('admin@system.com', 'admin2024');
      setState(() {
        if (result.success) {
          _message = '✅ نجح اختبار تسجيل الدخول: ${result.user?.name}';
        } else {
          _message = '❌ فشل اختبار تسجيل الدخول: ${result.message}';
        }
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

  Widget _buildConnectionCard() {
    if (_connectionStatus == null) return Container();

    final isConnected = _connectionStatus!['success'] == true;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConnected ? Icons.check_circle : Icons.error,
                  color: isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'حالة الاتصال بقاعدة البيانات',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (isConnected) ...[
              Text('الخادم: ${DatabaseConfig.host}:${DatabaseConfig.port}'),
              Text('قاعدة البيانات: ${DatabaseConfig.database}'),
              if (_connectionStatus!['version'] != null)
                Text('إصدار MySQL: ${_connectionStatus!['version']}'),
              if (_connectionStatus!['userCount'] != null)
                Text('عدد المستخدمين: ${_connectionStatus!['userCount']}'),
            ] else ...[
              Text(
                _connectionStatus!['message'] ?? 'خطأ غير معروف',
                style: const TextStyle(color: Colors.red),
              ),
              if (_connectionStatus!['error'] != null)
                Text(
                  'تفاصيل الخطأ: ${_connectionStatus!['error']}',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    if (_dbStats == null || _dbStats!['error'] != null) return Container();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات قاعدة البيانات',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('المدراء', _dbStats!['admin']?.toString() ?? '0', Colors.purple),
                _buildStatItem('الأطباء', _dbStats!['doctor']?.toString() ?? '0', Colors.blue),
                _buildStatItem('المرضى', _dbStats!['patient']?.toString() ?? '0', Colors.green),
                _buildStatItem('الإجمالي', _dbStats!['total']?.toString() ?? '0', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختبار قاعدة البيانات MySQL'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testConnection,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildConnectionCard(),
            _buildStatsCard(),
            
            // أزرار الاختبار
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _testConnection,
                          icon: const Icon(Icons.wifi_protected_setup),
                          label: const Text('اختبار الاتصال'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _testLogin,
                          icon: const Icon(Icons.login),
                          label: const Text('اختبار تسجيل الدخول'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _loadUsers,
                          icon: const Icon(Icons.people),
                          label: const Text('تحديث المستخدمين'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _clearDatabase,
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('مسح قاعدة البيانات'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // رسالة الحالة
            if (_message.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _message.startsWith('✅') ? Colors.green[50] : Colors.red[50],
                  border: Border.all(
                    color: _message.startsWith('✅') ? Colors.green : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _message.startsWith('✅') ? Icons.check_circle : Icons.error,
                      color: _message.startsWith('✅') ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _message,
                        style: TextStyle(
                          color: _message.startsWith('✅') ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // مؤشر التحميل
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),

            // قائمة المستخدمين
            if (_users.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'المستخدمون في قاعدة البيانات (${_users.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(user['role']),
                        child: Text(
                          user['name']?.toString().substring(0, 1) ?? '؟',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user['name']?.toString() ?? 'غير محدد'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['email']?.toString() ?? 'غير محدد'),
                          Text(
                            'الدور: ${_getRoleDisplayName(user['role'])}',
                            style: TextStyle(
                              color: _getRoleColor(user['role']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ID: ${user['id']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (user['phone'] != null)
                            Text(
                              user['phone'].toString(),
                              style: const TextStyle(fontSize: 10),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'doctor':
        return Colors.blue;
      case 'nurse':
        return Colors.teal;
      case 'patient':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(String? role) {
    switch (role) {
      case 'admin':
        return 'مدير';
      case 'doctor':
        return 'طبيب';
      case 'nurse':
        return 'ممرض';
      case 'patient':
        return 'مريض';
      default:
        return 'غير محدد';
    }
  }
}