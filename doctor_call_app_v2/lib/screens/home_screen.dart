import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'الرئيسية',
    ),
    NavigationItem(
      icon: Icons.local_hospital_outlined,
      selectedIcon: Icons.local_hospital,
      label: 'المستشفيات',
    ),
    NavigationItem(
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      label: 'المهام',
    ),
    NavigationItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'الملف الشخصي',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Call'),
        elevation: 0,
        actions: [
          // Notifications
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),

          // User Profile Menu
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;
              return PopupMenuButton(
                icon: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user?.name ?? 'مستخدم'),
                      subtitle: Text(user?.email ?? ''),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                    child: const ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('إعدادات الملف الشخصي'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navigationItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildHospitalsContent();
      case 2:
        return _buildMissionsContent();
      case 3:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              user?.name.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً، ${user?.name ?? 'مستخدم'}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                                Text(
                                  _getRoleDisplayName(user?.role ?? 'patient'),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'الإجراءات السريعة',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildQuickActionCard(
                    icon: Icons.local_hospital,
                    title: 'المستشفيات',
                    subtitle: 'عرض المستشفيات المتاحة',
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.assignment,
                    title: 'المهام',
                    subtitle: 'عرض المهام الحالية',
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.emoji_events,
                    title: 'الإنجازات',
                    subtitle: 'عرض الإنجازات والنقاط',
                    onTap: () => Navigator.pushNamed(context, '/achievements'),
                  ),
                  _buildQuickActionCard(
                    icon: Icons.leaderboard,
                    title: 'لوحة المتصدرين',
                    subtitle: 'ترتيب اللاعبين',
                    onTap: () => Navigator.pushNamed(context, '/leaderboard'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalsContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_hospital, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('صفحة المستشفيات'),
          Text('يتم تطوير هذه الصفحة...'),
        ],
      ),
    );
  }

  Widget _buildMissionsContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('صفحة المهام'),
          Text('يتم تطوير هذه الصفحة...'),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('الملف الشخصي'),
          Text('يتم تطوير هذه الصفحة...'),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return 'طبيب';
      case 'nurse':
        return 'ممرض/ة';
      case 'patient':
        return 'مريض';
      default:
        return 'مستخدم';
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}