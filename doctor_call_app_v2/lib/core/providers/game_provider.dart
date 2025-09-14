import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/game_models.dart';
import '../services/game_service.dart';
import '../services/notification_service.dart';

class GameProvider extends ChangeNotifier {
  final GameService _gameService = GameService();
  final NotificationService _notificationService = NotificationService();

  // Game state
  GameScore? _currentScore;
  List<Achievement> _allAchievements = [];
  List<Achievement> _userAchievements = [];
  List<LeaderboardEntry> _leaderboard = [];
  List<GameAction> _gameHistory = [];
  List<Map<String, dynamic>> _dailyChallenges = [];
  List<Map<String, dynamic>> _weeklyCheckallenges = [];
  List<Map<String, dynamic>> _seasonalEvents = [];

  // Loading states
  bool _isLoadingScore = false;
  bool _isLoadingAchievements = false;
  bool _isLoadingLeaderboard = false;
  bool _isLoadingHistory = false;
  bool _isLoadingChallenges = false;

  // Cache timestamps
  DateTime? _lastScoreUpdate;
  DateTime? _lastLeaderboardUpdate;
  DateTime? _lastAchievementsUpdate;

  // Getters
  GameScore? get currentScore => _currentScore;
  List<Achievement> get allAchievements => List.unmodifiable(_allAchievements);
  List<Achievement> get userAchievements =>
      List.unmodifiable(_userAchievements);
  List<LeaderboardEntry> get leaderboard => List.unmodifiable(_leaderboard);
  List<GameAction> get gameHistory => List.unmodifiable(_gameHistory);
  List<Map<String, dynamic>> get dailyChallenges =>
      List.unmodifiable(_dailyChallenges);
  List<Map<String, dynamic>> get weeklyChallenges =>
      List.unmodifiable(_weeklyCheckallenges);
  List<Map<String, dynamic>> get seasonalEvents =>
      List.unmodifiable(_seasonalEvents);

  bool get isLoadingScore => _isLoadingScore;
  bool get isLoadingAchievements => _isLoadingAchievements;
  bool get isLoadingLeaderboard => _isLoadingLeaderboard;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get isLoadingChallenges => _isLoadingChallenges;

  // Calculated properties
  int get totalUnlockedAchievements => _userAchievements.length;
  int get totalAvailableAchievements => _allAchievements.length;
  double get achievementProgress => _allAchievements.isEmpty
      ? 0.0
      : _userAchievements.length / _allAchievements.length;

  List<Achievement> get recentAchievements =>
      _userAchievements.where((a) => a.unlockedAt != null).toList()
        ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!))
        ..take(5);

  Map<String, List<Achievement>> get achievementsByCategory {
    final Map<String, List<Achievement>> grouped = {};
    for (final achievement in _allAchievements) {
      if (!grouped.containsKey(achievement.category)) {
        grouped[achievement.category] = [];
      }
      grouped[achievement.category]!.add(achievement);
    }
    return grouped;
  }

  List<Achievement> get unlockedAchievements =>
      _allAchievements.where((a) => a.isUnlocked).toList();

  List<Achievement> get lockedAchievements =>
      _allAchievements.where((a) => !a.isUnlocked).toList();

  /// Initialize game data
  Future<void> initialize(String token) async {
    await Future.wait([
      loadUserScore(token),
      loadAchievements(token),
      loadLeaderboard(token),
      loadChallenges(token),
    ]);
  }

  /// Load user's current game score
  Future<void> loadUserScore(String token) async {
    if (_isLoadingScore) return;

    _isLoadingScore = true;
    notifyListeners();

    try {
      _currentScore = await _gameService.getUserGameScore(token);
      _lastScoreUpdate = DateTime.now();
      notifyListeners();
    } catch (e) {
      print('Error loading user score: $e');
    } finally {
      _isLoadingScore = false;
      notifyListeners();
    }
  }

  /// Load all achievements and user achievements
  Future<void> loadAchievements(String token) async {
    if (_isLoadingAchievements) return;

    _isLoadingAchievements = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _gameService.getAllAchievements(token),
        _gameService.getUserAchievements(token),
      ]);

      _allAchievements = results[0] as List<Achievement>;
      _userAchievements = results[1] as List<Achievement>;
      _lastAchievementsUpdate = DateTime.now();
      notifyListeners();
    } catch (e) {
      print('Error loading achievements: $e');
    } finally {
      _isLoadingAchievements = false;
      notifyListeners();
    }
  }

  /// Load leaderboard
  Future<void> loadLeaderboard(
    String token, {
    String category = 'overall',
  }) async {
    if (_isLoadingLeaderboard) return;

    _isLoadingLeaderboard = true;
    notifyListeners();

    try {
      _leaderboard = await _gameService.getLeaderboard(
        token,
        category: category,
      );
      _lastLeaderboardUpdate = DateTime.now();
      notifyListeners();
    } catch (e) {
      print('Error loading leaderboard: $e');
    } finally {
      _isLoadingLeaderboard = false;
      notifyListeners();
    }
  }

  /// Load game history
  Future<void> loadGameHistory(String token) async {
    if (_isLoadingHistory) return;

    _isLoadingHistory = true;
    notifyListeners();

    try {
      _gameHistory = await _gameService.getUserGameHistory(token);
      notifyListeners();
    } catch (e) {
      print('Error loading game history: $e');
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  /// Load challenges
  Future<void> loadChallenges(String token) async {
    if (_isLoadingChallenges) return;

    _isLoadingChallenges = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _gameService.getChallenges(token, period: 'daily'),
        _gameService.getChallenges(token, period: 'weekly'),
        _gameService.getSeasonalEvents(token),
      ]);

      _dailyChallenges = results[0] as List<Map<String, dynamic>>;
      _weeklyCheckallenges = results[1] as List<Map<String, dynamic>>;
      _seasonalEvents = results[2] as List<Map<String, dynamic>>;
      notifyListeners();
    } catch (e) {
      print('Error loading challenges: $e');
    } finally {
      _isLoadingChallenges = false;
      notifyListeners();
    }
  }

  /// Submit a game action and update score
  Future<Map<String, dynamic>?> submitGameAction(
    String actionType,
    Map<String, dynamic> actionData,
    String token,
  ) async {
    try {
      final result = await _gameService.submitGameAction(
        actionType,
        actionData,
        token,
      );

      // Update local score if points were earned
      if (result['points_earned'] != null && result['points_earned'] > 0) {
        await loadUserScore(token);

        // Show notification for points earned
        _notificationService.sendCustomNotification(
          title: 'نقاط جديدة! 🎉',
          body: 'لقد حصلت على ${result['points_earned']} نقطة',
          type: NotificationType.gameAchievement,
          payload: result,
        );
      }

      // Check for new achievements
      if (result['new_achievements'] != null &&
          (result['new_achievements'] as List).isNotEmpty) {
        await loadAchievements(token);

        for (final achievementData in result['new_achievements']) {
          _notificationService.sendCustomNotification(
            title: 'إنجاز جديد! 🏆',
            body: 'لقد حصلت على إنجاز: ${achievementData['name']}',
            type: NotificationType.gameAchievement,
            payload: achievementData,
          );
        }
      }

      // Check for level up
      if (result['level_up'] == true) {
        _notificationService.sendCustomNotification(
          title: 'مستوى جديد! ⭐',
          body: 'مبروك! لقد وصلت للمستوى ${result['new_level']}',
          type: NotificationType.gameAchievement,
          payload: result,
        );
      }

      return result;
    } catch (e) {
      print('Error submitting game action: $e');
      return null;
    }
  }

  /// Submit patient care action
  Future<void> submitPatientCare({
    required int patientId,
    required String actionType,
    required int timeSpent,
    required Map<String, dynamic> details,
    required String token,
  }) async {
    await submitGameAction(GameActionType.patientAdmitted, {
      'patient_id': patientId,
      'action_type': actionType,
      'time_spent': timeSpent,
      'details': details,
    }, token);
  }

  /// Submit emergency response
  Future<void> submitEmergencyResponse({
    required String emergencyType,
    required int responseTime,
    required String outcome,
    required String token,
  }) async {
    await submitGameAction(GameActionType.emergencyHandled, {
      'emergency_type': emergencyType,
      'response_time': responseTime,
      'outcome': outcome,
    }, token);
  }

  /// Submit hospital management action
  Future<void> submitHospitalManagement({
    required int hospitalId,
    required String actionType,
    required Map<String, dynamic> improvements,
    required String token,
  }) async {
    await submitGameAction(GameActionType.hospitalManaged, {
      'hospital_id': hospitalId,
      'action_type': actionType,
      'improvements': improvements,
    }, token);
  }

  /// Complete a challenge
  Future<void> completeChallenge(int challengeId, String token) async {
    try {
      final result = await _gameService.completeChallenge(challengeId, token);

      // Reload challenges and score
      await Future.wait([loadChallenges(token), loadUserScore(token)]);

      // Show notification
      _notificationService.sendCustomNotification(
        title: 'تحدي مكتمل! 🎯',
        body: 'لقد أكملت التحدي وحصلت على ${result['points']} نقطة',
        type: NotificationType.gameAchievement,
        payload: result,
      );
    } catch (e) {
      print('Error completing challenge: $e');
    }
  }

  /// Claim achievement reward
  Future<void> claimAchievementReward(int achievementId, String token) async {
    try {
      final result = await _gameService.claimAchievementReward(
        achievementId,
        token,
      );

      // Reload score and achievements
      await Future.wait([loadUserScore(token), loadAchievements(token)]);

      // Show notification
      _notificationService.sendCustomNotification(
        title: 'مكافأة محصلة! 🎁',
        body: result['message'] ?? 'لقد حصلت على مكافأة الإنجاز',
        type: NotificationType.gameAchievement,
        payload: result,
      );
    } catch (e) {
      print('Error claiming reward: $e');
    }
  }

  /// Get achievement by ID
  Achievement? getAchievementById(int id) {
    try {
      return _allAchievements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get achievements by category
  List<Achievement> getAchievementsByCategory(String category) {
    return _allAchievements.where((a) => a.category == category).toList();
  }

  /// Get user's rank position
  int? getUserRankPosition() {
    return _currentScore?.rank;
  }

  /// Get user's progress to next achievement in category
  Map<String, dynamic>? getNextAchievementProgress(String category) {
    final categoryAchievements =
        getAchievementsByCategory(category).where((a) => !a.isUnlocked).toList()
          ..sort((a, b) => a.requiredPoints.compareTo(b.requiredPoints));

    if (categoryAchievements.isEmpty || _currentScore == null) return null;

    final nextAchievement = categoryAchievements.first;
    final currentPoints = _currentScore!.categoryPoints[category] ?? 0;
    final progress = currentPoints / nextAchievement.requiredPoints;

    return {
      'achievement': nextAchievement,
      'current_points': currentPoints,
      'required_points': nextAchievement.requiredPoints,
      'progress': progress.clamp(0.0, 1.0),
      'points_needed': (nextAchievement.requiredPoints - currentPoints).clamp(
        0,
        nextAchievement.requiredPoints,
      ),
    };
  }

  /// Check if data needs refresh
  bool needsRefresh({Duration maxAge = const Duration(minutes: 5)}) {
    final now = DateTime.now();

    return _lastScoreUpdate == null ||
        _lastLeaderboardUpdate == null ||
        _lastAchievementsUpdate == null ||
        now.difference(_lastScoreUpdate!).compareTo(maxAge) > 0 ||
        now.difference(_lastLeaderboardUpdate!).compareTo(maxAge) > 0 ||
        now.difference(_lastAchievementsUpdate!).compareTo(maxAge) > 0;
  }

  /// Refresh all game data
  Future<void> refreshAll(String token) async {
    await initialize(token);
  }

  /// Clear all game data
  void clearGameData() {
    _currentScore = null;
    _allAchievements.clear();
    _userAchievements.clear();
    _leaderboard.clear();
    _gameHistory.clear();
    _dailyChallenges.clear();
    _weeklyCheckallenges.clear();
    _seasonalEvents.clear();
    _lastScoreUpdate = null;
    _lastLeaderboardUpdate = null;
    _lastAchievementsUpdate = null;
    notifyListeners();
  }
}
