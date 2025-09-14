import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/game_provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/models/game_models.dart';

class GameStatsScreen extends StatefulWidget {
  const GameStatsScreen({super.key});

  @override
  State<GameStatsScreen> createState() => _GameStatsScreenState();
}

class _GameStatsScreenState extends State<GameStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGameData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGameData() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token != null) {
      await Future.wait([
        gameProvider.loadUserScore(authProvider.token!),
        gameProvider.loadGameHistory(authProvider.token!),
        gameProvider.loadAchievements(authProvider.token!),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(gameProvider),
              _buildOverviewCards(gameProvider),
              _buildTabBar(),
              _buildTabBarView(gameProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(GameProvider gameProvider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'إحصائيات الألعاب',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 40,
                left: 20,
                child: Icon(
                  Icons.analytics,
                  color: Colors.white.withOpacity(0.1),
                  size: 80,
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Icon(
                  Icons.trending_up,
                  color: Colors.white.withOpacity(0.1),
                  size: 60,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _loadGameData,
        ),
      ],
    );
  }

  Widget _buildOverviewCards(GameProvider gameProvider) {
    final currentScore = gameProvider.currentScore;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Main stats card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إحصائياتك الشاملة',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'أداؤك في النظام',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats grid
                  if (currentScore != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'إجمالي النقاط',
                            '${currentScore.totalPoints}',
                            Icons.stars,
                            Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'المستوى',
                            '${currentScore.level}',
                            Icons.trending_up,
                            Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'الخبرة',
                            '${currentScore.experience}',
                            Icons.school,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'الترتيب',
                            '#${currentScore.rank ?? '--'}',
                            Icons.leaderboard,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لا توجد بيانات إحصائية',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ابدأ بتقديم الخدمات لبناء إحصائياتك',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    'الإنجازات',
                    '${gameProvider.totalUnlockedAchievements}/${gameProvider.totalAvailableAchievements}',
                    Icons.emoji_events,
                    Colors.orange,
                    () => Navigator.pushNamed(context, '/achievements'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    'التحديات',
                    'اليومية والأسبوعية',
                    Icons.assignment,
                    Colors.green,
                    () => Navigator.pushNamed(context, '/challenges'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'التقدم'),
            Tab(icon: Icon(Icons.category), text: 'الفئات'),
            Tab(icon: Icon(Icons.history), text: 'النشاط'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(GameProvider gameProvider) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildProgressTab(gameProvider),
          _buildCategoriesTab(gameProvider),
          _buildActivityTab(gameProvider),
        ],
      ),
    );
  }

  Widget _buildProgressTab(GameProvider gameProvider) {
    final currentScore = gameProvider.currentScore;

    return RefreshIndicator(
      onRefresh: _loadGameData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Level progress
          if (currentScore != null) ...[
            _buildProgressCard(
              'تقدم المستوى',
              'المستوى ${currentScore.level}',
              currentScore.experience.toDouble(),
              _getExpForNextLevel(currentScore.level).toDouble(),
              Icons.trending_up,
              Colors.blue,
              'خبرة',
            ),
            const SizedBox(height: 16),

            // Achievement progress
            _buildProgressCard(
              'تقدم الإنجازات',
              '${gameProvider.totalUnlockedAchievements} إنجاز',
              gameProvider.totalUnlockedAchievements.toDouble(),
              gameProvider.totalAvailableAchievements.toDouble(),
              Icons.emoji_events,
              Colors.orange,
              'إنجاز',
            ),
            const SizedBox(height: 16),

            // Category progress
            if (currentScore.categoryPoints.isNotEmpty) ...[
              Text(
                'التقدم حسب الفئة',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...currentScore.categoryPoints.entries.map((entry) {
                final categoryName = _getCategoryName(entry.key);
                final categoryIcon = _getCategoryIcon(entry.key);
                final categoryColor = _getCategoryColor(entry.key);
                final nextAchievement = gameProvider.getNextAchievementProgress(
                  entry.key,
                );

                if (nextAchievement != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildProgressCard(
                      categoryName,
                      'إلى الإنجاز التالي',
                      nextAchievement['current_points'].toDouble(),
                      nextAchievement['required_points'].toDouble(),
                      categoryIcon,
                      categoryColor,
                      'نقطة',
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(categoryIcon, color: Colors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoryName,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'جميع الإنجازات مكتملة!',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${entry.value} نقطة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }).toList(),
            ],
          ] else ...[
            _buildEmptyState(
              'لا توجد بيانات تقدم',
              'ابدأ بتقديم الخدمات لرؤية تقدمك',
              Icons.timeline,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(GameProvider gameProvider) {
    final categories = [
      'patient_care',
      'emergency_response',
      'hospital_management',
    ];

    return RefreshIndicator(
      onRefresh: _loadGameData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryAchievements = gameProvider.getAchievementsByCategory(
            category,
          );
          final unlockedCount = categoryAchievements
              .where((a) => a.isUnlocked)
              .length;
          final totalPoints =
              gameProvider.currentScore?.categoryPoints[category] ?? 0;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getCategoryIcon(category),
                          color: _getCategoryColor(category),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getCategoryName(category),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$unlockedCount من ${categoryAchievements.length} إنجاز',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$totalPoints',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getCategoryColor(category),
                                ),
                          ),
                          Text(
                            'نقطة',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress bar
                  LinearProgressIndicator(
                    value: categoryAchievements.isEmpty
                        ? 0.0
                        : unlockedCount / categoryAchievements.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getCategoryColor(category),
                    ),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    '${((categoryAchievements.isEmpty ? 0 : unlockedCount / categoryAchievements.length) * 100).toInt()}% مكتمل',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityTab(GameProvider gameProvider) {
    return RefreshIndicator(
      onRefresh: _loadGameData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (gameProvider.gameHistory.isNotEmpty) ...[
            Text(
              'النشاط الأخير',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...gameProvider.gameHistory.take(10).map((action) {
              return _buildActivityCard(action);
            }).toList(),
          ] else ...[
            _buildEmptyState(
              'لا يوجد نشاط مسجل',
              'سيظهر نشاطك هنا عند تقديم الخدمات',
              Icons.history,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    String title,
    String subtitle,
    double current,
    double total,
    IconData icon,
    Color color,
    String unit,
  ) {
    final progress = total > 0 ? current / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                '${current.toInt()}/${total.toInt()} $unit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% مكتمل',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(GameAction action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getActionTypeColor(action.actionType).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActionTypeIcon(action.actionType),
              color: _getActionTypeColor(action.actionType),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getActionTypeName(action.actionType),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  _formatActionDate(action.createdAt),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (action.pointsEarned > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${action.pointsEarned}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  int _getExpForNextLevel(int currentLevel) {
    return currentLevel * 1000; // Simple formula
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'patient_care':
        return 'رعاية المرضى';
      case 'emergency_response':
        return 'الطوارئ';
      case 'hospital_management':
        return 'إدارة المستشفى';
      default:
        return category;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'patient_care':
        return Icons.local_hospital;
      case 'emergency_response':
        return Icons.emergency;
      case 'hospital_management':
        return Icons.business;
      default:
        return Icons.star;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'patient_care':
        return Colors.blue;
      case 'emergency_response':
        return Colors.red;
      case 'hospital_management':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getActionTypeColor(String actionType) {
    switch (actionType) {
      case GameActionType.patientAdmitted:
      case GameActionType.patientTreated:
        return Colors.blue;
      case GameActionType.emergencyHandled:
        return Colors.red;
      case GameActionType.hospitalManaged:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionTypeIcon(String actionType) {
    switch (actionType) {
      case GameActionType.patientAdmitted:
      case GameActionType.patientTreated:
        return Icons.local_hospital;
      case GameActionType.emergencyHandled:
        return Icons.emergency;
      case GameActionType.hospitalManaged:
        return Icons.business;
      default:
        return Icons.star;
    }
  }

  String _getActionTypeName(String actionType) {
    switch (actionType) {
      case GameActionType.patientAdmitted:
        return 'استقبال مريض';
      case GameActionType.patientTreated:
        return 'علاج مريض';
      case GameActionType.emergencyHandled:
        return 'حالة طوارئ';
      case GameActionType.hospitalManaged:
        return 'إدارة مستشفى';
      default:
        return actionType;
    }
  }

  String _formatActionDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
