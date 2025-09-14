import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/game_provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/models/game_models.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل',
    'patient_care',
    'emergency_response',
    'hospital_management',
    'special_events',
  ];

  final Map<String, String> _categoryNames = {
    'الكل': 'جميع الإنجازات',
    'patient_care': 'رعاية المرضى',
    'emergency_response': 'الطوارئ',
    'hospital_management': 'إدارة المستشفى',
    'special_events': 'الأحداث الخاصة',
  };

  final Map<String, IconData> _categoryIcons = {
    'الكل': Icons.star,
    'patient_care': Icons.local_hospital,
    'emergency_response': Icons.emergency,
    'hospital_management': Icons.business,
    'special_events': Icons.event,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAchievements();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token != null) {
      await gameProvider.loadAchievements(authProvider.token!);
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
              _buildProgressHeader(gameProvider),
              _buildCategoryFilter(),
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
          'الإنجازات',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: gameProvider.isLoadingAchievements
              ? null
              : _loadAchievements,
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onSelected: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          itemBuilder: (context) => _categories.map((category) {
            return PopupMenuItem(
              value: category,
              child: Row(
                children: [
                  Icon(_categoryIcons[category]),
                  const SizedBox(width: 8),
                  Text(_categoryNames[category] ?? category),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProgressHeader(GameProvider gameProvider) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.trophy,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التقدم الإجمالي',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${gameProvider.totalUnlockedAchievements} من ${gameProvider.totalAvailableAchievements} إنجاز',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(gameProvider.achievementProgress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: gameProvider.achievementProgress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = category == _selectedCategory;

            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _categoryIcons[category],
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _categoryNames[category] ?? category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                backgroundColor: Colors.grey[100],
                selectedColor: Theme.of(context).primaryColor,
              ),
            );
          },
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
            Tab(icon: Icon(Icons.check_circle), text: 'مكتملة'),
            Tab(icon: Icon(Icons.radio_button_unchecked), text: 'قيد التقدم'),
            Tab(icon: Icon(Icons.star), text: 'حديثة'),
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
          _buildAchievementsList(
            gameProvider.unlockedAchievements,
            gameProvider,
          ),
          _buildAchievementsList(gameProvider.lockedAchievements, gameProvider),
          _buildAchievementsList(gameProvider.recentAchievements, gameProvider),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(
    List<Achievement> achievements,
    GameProvider gameProvider,
  ) {
    // Filter by selected category
    List<Achievement> filteredAchievements = achievements;
    if (_selectedCategory != 'الكل') {
      filteredAchievements = achievements
          .where((a) => a.category == _selectedCategory)
          .toList();
    }

    if (gameProvider.isLoadingAchievements) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('جارٍ تحميل الإنجازات...'),
          ],
        ),
      );
    }

    if (filteredAchievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد إنجازات في هذه الفئة',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'ابدأ بتقديم الخدمات لكسب إنجازات جديدة',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAchievements,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredAchievements.length,
        itemBuilder: (context, index) {
          final achievement = filteredAchievements[index];
          return _buildAchievementCard(achievement, gameProvider);
        },
      ),
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement,
    GameProvider gameProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: achievement.isUnlocked
              ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showAchievementDetails(achievement, gameProvider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Achievement Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? _getRarityColor(achievement.rarity).withValues(alpha: 0.1)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: achievement.isUnlocked
                        ? _getRarityColor(achievement.rarity)
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(achievement.category),
                  color: achievement.isUnlocked
                      ? _getRarityColor(achievement.rarity)
                      : Colors.grey[400],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Achievement Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            achievement.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: achievement.isUnlocked
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                          ),
                        ),
                        if (achievement.isUnlocked) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getRarityColor(achievement.rarity),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getRarityName(achievement.rarity),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Progress or completion info
                    if (achievement.isUnlocked) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'مكتمل في ${_formatDate(achievement.unlockedAt!)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const Spacer(),
                          if (achievement.points > 0) ...[
                            Icon(Icons.stars, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${achievement.points} نقطة',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.amber[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ] else ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'المطلوب: ${achievement.requiredPoints} نقطة',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const Spacer(),
                              if (achievement.points > 0) ...[
                                Icon(
                                  Icons.stars_outlined,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${achievement.points} نقطة',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value:
                                (achievement.currentProgress /
                                        achievement.requiredPoints)
                                    .clamp(0.0, 1.0),
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor.withValues(alpha: 0.7),
                            ),
                            minHeight: 4,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Action button
              const SizedBox(width: 8),
              if (achievement.isUnlocked &&
                  achievement.hasReward &&
                  !achievement.rewardClaimed) ...[
                ElevatedButton(
                  onPressed: () => _claimReward(achievement, gameProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('استلام', style: TextStyle(fontSize: 12)),
                ),
              ] else if (!achievement.isUnlocked) ...[
                Icon(Icons.lock_outline, color: Colors.grey[400]),
              ] else ...[
                Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(
    Achievement achievement,
    GameProvider gameProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Achievement header
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: achievement.isUnlocked
                            ? _getRarityColor(
                                achievement.rarity,
                              ).withValues(alpha: 0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: achievement.isUnlocked
                              ? _getRarityColor(achievement.rarity)
                              : Colors.grey[300]!,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        _getCategoryIcon(achievement.category),
                        color: achievement.isUnlocked
                            ? _getRarityColor(achievement.rarity)
                            : Colors.grey[400],
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getRarityColor(
                                achievement.rarity,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _getRarityColor(achievement.rarity),
                              ),
                            ),
                            child: Text(
                              _getRarityName(achievement.rarity),
                              style: TextStyle(
                                color: _getRarityColor(achievement.rarity),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'الوصف',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  achievement.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // Requirements
                Text(
                  'المتطلبات',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'النقاط المطلوبة:',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${achievement.requiredPoints}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (!achievement.isUnlocked) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'التقدم الحالي:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${achievement.currentProgress}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value:
                              (achievement.currentProgress /
                                      achievement.requiredPoints)
                                  .clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                          minHeight: 8,
                        ),
                      ],
                    ],
                  ),
                ),

                // Rewards
                if (achievement.points > 0 || achievement.hasReward) ...[
                  const SizedBox(height: 24),
                  Text(
                    'المكافآت',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.stars, color: Colors.amber[700], size: 24),
                        const SizedBox(width: 12),
                        Text(
                          '${achievement.points} نقطة',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.amber[700],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Status
                const SizedBox(height: 24),
                if (achievement.isUnlocked) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تم إنجازه!',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'مكتمل في ${_formatDate(achievement.unlockedAt!)}',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.green[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Claim reward button
                  if (achievement.hasReward && !achievement.rewardClaimed) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _claimReward(achievement, gameProvider);
                        },
                        icon: const Icon(Icons.card_giftcard),
                        label: const Text('استلام المكافأة'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.orange[600],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'قيد التقدم',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Colors.orange[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'اكمل ${achievement.requiredPoints - achievement.currentProgress} نقطة إضافية',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.orange[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _claimReward(
    Achievement achievement,
    GameProvider gameProvider,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.token != null) {
      await gameProvider.claimAchievementReward(
        achievement.id,
        authProvider.token!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم استلام مكافأة "${achievement.name}"'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return Colors.grey;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getRarityName(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common':
        return 'عادي';
      case 'rare':
        return 'نادر';
      case 'epic':
        return 'ملحمي';
      case 'legendary':
        return 'أسطوري';
      default:
        return rarity;
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
      case 'special_events':
        return Icons.event;
      default:
        return Icons.star;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      return 'منذ ${(difference.inDays / 7).floor()} أسابيع';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
