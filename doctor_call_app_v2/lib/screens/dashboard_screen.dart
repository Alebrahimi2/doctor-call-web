import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<DashboardItem> _dashboardItems = [
    DashboardItem(
      icon: Icons.dashboard,
      title: 'Overview',
      subtitle: 'System overview and statistics',
    ),
    DashboardItem(
      icon: Icons.local_hospital,
      title: 'Hospitals',
      subtitle: 'Manage hospital information',
    ),
    DashboardItem(
      icon: Icons.people,
      title: 'Patients',
      subtitle: 'Patient management and records',
    ),
    DashboardItem(
      icon: Icons.assignment,
      title: 'Missions',
      subtitle: 'View and manage missions',
    ),
    DashboardItem(
      icon: Icons.analytics,
      title: 'Analytics',
      subtitle: 'Performance analytics and reports',
    ),
    DashboardItem(
      icon: Icons.settings,
      title: 'Settings',
      subtitle: 'System configuration',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Call Dashboard'),
        elevation: 0,
        actions: [
          // Notifications
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              // TODO: Show notifications
            },
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
                      title: Text(user?.name ?? 'User'),
                      subtitle: Text(user?.email ?? ''),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Profile Settings'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help & Support'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    onTap: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                    child: const ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: _dashboardItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              );
            }).toList(),
          ),

          const VerticalDivider(thickness: 1, width: 1),

          // Main Content Area
          Expanded(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return _buildHospitalsContent();
      case 2:
        return _buildPatientsContent();
      case 3:
        return _buildMissionsContent();
      case 4:
        return _buildAnalyticsContent();
      case 5:
        return _buildSettingsContent();
      default:
        return _buildOverviewContent();
    }
  }

  Widget _buildOverviewContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.user;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${user?.name ?? 'User'}!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Here\'s what\'s happening in your hospital system today.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Statistics Cards
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Total Hospitals',
                '12',
                Icons.local_hospital,
                Colors.blue,
              ),
              _buildStatCard(
                'Active Patients',
                '345',
                Icons.people,
                Colors.green,
              ),
              _buildStatCard(
                'Ongoing Missions',
                '28',
                Icons.assignment,
                Colors.orange,
              ),
              _buildStatCard(
                'Completed Today',
                '56',
                Icons.check_circle,
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(
                            Icons.local_hospital,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        title: Text('New patient admitted to City Hospital'),
                        subtitle: Text('2 minutes ago'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalsContent() {
    return const Center(child: Text('Hospitals Management - Coming Soon'));
  }

  Widget _buildPatientsContent() {
    return const Center(child: Text('Patients Management - Coming Soon'));
  }

  Widget _buildMissionsContent() {
    return const Center(child: Text('Missions Management - Coming Soon'));
  }

  Widget _buildAnalyticsContent() {
    return const Center(child: Text('Analytics Dashboard - Coming Soon'));
  }

  Widget _buildSettingsContent() {
    return const Center(child: Text('System Settings - Coming Soon'));
  }
}

class DashboardItem {
  final IconData icon;
  final String title;
  final String subtitle;

  DashboardItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
