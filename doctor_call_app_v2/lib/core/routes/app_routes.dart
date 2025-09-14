import 'package:flutter/material.dart';
import '../../screens/login_screen.dart';
import '../../screens/register_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/patients_screen.dart';
import '../../screens/hospitals_screen.dart';
import '../../screens/notifications_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/achievements_screen.dart';
import '../../screens/leaderboard_screen.dart';
import '../../screens/challenges_screen.dart';
import '../../screens/game_stats_screen.dart';
import '../../screens/database_test_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String patients = '/patients';
  static const String hospitals = '/hospitals';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String achievements = '/achievements';
  static const String leaderboard = '/leaderboard';
  static const String challenges = '/challenges';
  static const String gameStats = '/game-stats';
  static const String databaseTest = '/database-test';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      patients: (context) => const PatientsScreen(),
      hospitals: (context) => const HospitalsScreen(),
      notifications: (context) => const NotificationsScreen(),
      profile: (context) => const ProfileScreen(),
      achievements: (context) => const AchievementsScreen(),
      leaderboard: (context) => const LeaderboardScreen(),
      challenges: (context) => const ChallengesScreen(),
      gameStats: (context) => const GameStatsScreen(),
      databaseTest: (context) => const DatabaseTestScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
          settings: settings,
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
          settings: settings,
        );
      case patients:
        return MaterialPageRoute(
          builder: (context) => const PatientsScreen(),
          settings: settings,
        );
      case hospitals:
        return MaterialPageRoute(
          builder: (context) => const HospitalsScreen(),
          settings: settings,
        );
      case notifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
          settings: settings,
        );
      case achievements:
        return MaterialPageRoute(
          builder: (context) => const AchievementsScreen(),
          settings: settings,
        );
      case leaderboard:
        return MaterialPageRoute(
          builder: (context) => const LeaderboardScreen(),
          settings: settings,
        );
      case challenges:
        return MaterialPageRoute(
          builder: (context) => const ChallengesScreen(),
          settings: settings,
        );
      case gameStats:
        return MaterialPageRoute(
          builder: (context) => const GameStatsScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('الصفحة غير موجودة'))),
          settings: settings,
        );
    }
  }
}

// Game navigation helper class
class GameNavigation {
  static void navigateToAchievements(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.achievements);
  }

  static void navigateToLeaderboard(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.leaderboard);
  }

  static void navigateToChallenges(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.challenges);
  }

  static void navigateToGameStats(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.gameStats);
  }

  static void showGameMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              'قائمة الألعاب',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Menu items
            _buildGameMenuItem(
              context,
              'الإنجازات',
              'تتبع إنجازاتك ومكافآتك',
              Icons.emoji_events,
              Colors.orange,
              () => navigateToAchievements(context),
            ),
            _buildGameMenuItem(
              context,
              'المتصدرين',
              'شاهد ترتيبك بين الأطباء',
              Icons.leaderboard,
              Colors.purple,
              () => navigateToLeaderboard(context),
            ),
            _buildGameMenuItem(
              context,
              'التحديات',
              'التحديات اليومية والأسبوعية',
              Icons.assignment,
              Colors.green,
              () => navigateToChallenges(context),
            ),
            _buildGameMenuItem(
              context,
              'الإحصائيات',
              'تحليل أدائك ونشاطك',
              Icons.analytics,
              Colors.blue,
              () => navigateToGameStats(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildGameMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
