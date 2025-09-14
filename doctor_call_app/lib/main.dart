import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/services/api_service.dart'; // استيراد خدمة الـ API

void main() {
  runZonedGuarded(() {
    // معالجة أخطاء Flutter Framework
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
      dev.log('FlutterError',
          name: 'app', error: details.exception, stackTrace: details.stack);
    };

    // معالجة أخطاء المنصة (Platform)
    PlatformDispatcher.instance.onError = (error, stack) {
      dev.log('PlatformError', name: 'app', error: error, stackTrace: stack);
      return true; // يعني أننا عالجنا الخطأ
    };

    // عرض واجهة مخصصة للأخطاء بدلاً من الشاشة الحمراء/البيضاء
    ErrorWidget.builder = (details) => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('حدث خطأ في التطبيق')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  'نعتذر، حدث خطأ غير متوقع.\n\n'
                  'تفاصيل الخطأ:\n${details.toString()}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ),
        );

    runApp(const MyApp());
  }, (error, stack) {
    // معالجة الأخطاء التي لم يتم التقاطها في Flutter/Dart
    dev.log('ZonedError', name: 'app', error: error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة المستشفى',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const UserDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int selectedIndex = 0;
  late Future<Map<String, dynamic>> _statsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _statsFuture = _apiService.getDashboardStats();
  }

  void _refreshStats() {
    setState(() {
      _statsFuture = _apiService.getDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('نظام إدارة المستشفى - Doctor Call'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: _buildMainContent(isDesktop, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_hospital, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Doctor Call',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  'نظام إدارة المستشفى',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildMenuItems(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: const Column(
              children: [
                Icon(Icons.local_hospital, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Doctor Call',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  'نظام إدارة المستشفى',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildMenuItems(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'title': 'لوحة التحكم', 'icon': Icons.dashboard, 'index': 0},
      {'title': 'المرضى', 'icon': Icons.people, 'index': 1},
      {'title': 'الأطباء', 'icon': Icons.medical_services, 'index': 2},
      {'title': 'المواعيد', 'icon': Icons.calendar_today, 'index': 3},
      {'title': 'الأقسام', 'icon': Icons.domain, 'index': 4},
      {'title': 'التقارير', 'icon': Icons.analytics, 'index': 5},
      {'title': 'الإعدادات', 'icon': Icons.settings, 'index': 6},
    ];

    return ListView(
      children: menuItems.map((item) {
        final isSelected = selectedIndex == item['index'];
        return ListTile(
          leading: Icon(
            item['icon'] as IconData,
            color: isSelected ? Colors.blue : Colors.grey.shade600,
          ),
          title: Text(
            item['title'] as String,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey.shade800,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          selectedTileColor: Colors.blue.shade100,
          onTap: () {
            setState(() {
              selectedIndex = item['index'] as int;
            });
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildMainContent(bool isDesktop, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بك في لوحة التحكم',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'نظرة عامة على إحصائيات المستشفى',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.blue),
                tooltip: 'تحديث البيانات',
                onPressed: _refreshStats,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('حدث خطأ في جلب البيانات: ${snapshot.error}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _refreshStats,
                          child: const Text('إعادة المحاولة'),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  final dashboardItems = [
                    {
                      'title': 'المرضى',
                      'icon': Icons.people,
                      'count': stats['patients']?.toString() ?? '0',
                      'color': Colors.blue,
                    },
                    {
                      'title': 'الأطباء',
                      'icon': Icons.medical_services,
                      'count': stats['staff']?.toString() ?? '0',
                      'color': Colors.green,
                    },
                    {
                      'title': 'المهمات',
                      'icon': Icons.assignment,
                      'count': stats['missions']?.toString() ?? '0',
                      'color': Colors.orange,
                    },
                    {
                      'title': 'الأقسام',
                      'icon': Icons.domain,
                      'count': stats['departments']?.toString() ?? '0',
                      'color': Colors.purple,
                    },
                  ];

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: dashboardItems.length,
                    itemBuilder: (context, index) {
                      final item = dashboardItems[index];
                      return _buildDashboardCard(
                        title: item['title'] as String,
                        count: item['count'] as String,
                        icon: item['icon'] as IconData,
                        color: item['color'] as Color,
                      );
                    },
                  );
                }
                return const Center(child: Text('لا توجد بيانات لعرضها'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      {required String title,
      required String count,
      required IconData icon,
      required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
