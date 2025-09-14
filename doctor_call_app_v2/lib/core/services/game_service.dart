import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_models.dart';
import '../constants/api_constants.dart';

class GameService {
  static const String baseUrl = ApiConstants.baseUrl;

  /// Get user's current game score and level
  Future<GameScore> getUserGameScore(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/score'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return GameScore.fromJson(data['data']);
      } else {
        throw Exception('Failed to load game score: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading game score: $e');
    }
  }

  /// Get all available achievements
  Future<List<Achievement>> getAllAchievements(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/achievements'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> achievementsJson = data['data'] ?? [];
        return achievementsJson.map((json) => Achievement.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load achievements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading achievements: $e');
    }
  }

  /// Get user's unlocked achievements
  Future<List<Achievement>> getUserAchievements(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/achievements/my'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> achievementsJson = data['data'] ?? [];
        return achievementsJson.map((json) => Achievement.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user achievements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading user achievements: $e');
    }
  }

  /// Get leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard(String token, {
    String category = 'overall',
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/leaderboard?category=$category&limit=$limit&offset=$offset'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> leaderboardJson = data['data'] ?? [];
        return leaderboardJson.map((json) => LeaderboardEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading leaderboard: $e');
    }
  }

  /// Submit game action and earn points
  Future<Map<String, dynamic>> submitGameAction(
    String actionType,
    Map<String, dynamic> actionData,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/action'),
        headers: ApiConstants.getAuthHeaders(token),
        body: json.encode({
          'type': actionType,
          'data': actionData,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit game action: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting game action: $e');
    }
  }

  /// Get user's game activity history
  Future<List<GameAction>> getUserGameHistory(String token, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/history?limit=$limit&offset=$offset'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> historyJson = data['data'] ?? [];
        return historyJson.map((json) => GameAction.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load game history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading game history: $e');
    }
  }

  /// Get achievements by category
  Future<List<Achievement>> getAchievementsByCategory(String category, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/achievements/category/$category'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> achievementsJson = data['data'] ?? [];
        return achievementsJson.map((json) => Achievement.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category achievements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading category achievements: $e');
    }
  }

  /// Claim achievement reward
  Future<Map<String, dynamic>> claimAchievementReward(int achievementId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/achievements/$achievementId/claim'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to claim reward: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error claiming reward: $e');
    }
  }

  /// Get daily/weekly challenges
  Future<List<Map<String, dynamic>>> getChallenges(String token, {String period = 'daily'}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/challenges?period=$period'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load challenges: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading challenges: $e');
    }
  }

  /// Complete a challenge
  Future<Map<String, dynamic>> completeChallenge(int challengeId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/challenges/$challengeId/complete'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to complete challenge: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error completing challenge: $e');
    }
  }

  /// Get game statistics
  Future<Map<String, dynamic>> getGameStatistics(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/stats'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load game statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading game statistics: $e');
    }
  }

  /// Submit patient care action
  Future<Map<String, dynamic>> submitPatientCareAction({
    required int patientId,
    required String actionType,
    required int timeSpent,
    required Map<String, dynamic> details,
    required String token,
  }) async {
    return await submitGameAction(
      GameActionType.patientAdmitted,
      {
        'patient_id': patientId,
        'action_type': actionType,
        'time_spent': timeSpent,
        'details': details,
      },
      token,
    );
  }

  /// Submit emergency response action
  Future<Map<String, dynamic>> submitEmergencyResponse({
    required String emergencyType,
    required int responseTime,
    required String outcome,
    required Map<String, dynamic> details,
    required String token,
  }) async {
    return await submitGameAction(
      GameActionType.emergencyHandled,
      {
        'emergency_type': emergencyType,
        'response_time': responseTime,
        'outcome': outcome,
        'details': details,
      },
      token,
    );
  }

  /// Submit hospital management action
  Future<Map<String, dynamic>> submitHospitalManagement({
    required int hospitalId,
    required String actionType,
    required Map<String, dynamic> improvements,
    required String token,
  }) async {
    return await submitGameAction(
      GameActionType.hospitalManaged,
      {
        'hospital_id': hospitalId,
        'action_type': actionType,
        'improvements': improvements,
      },
      token,
    );
  }

  /// Submit team collaboration action
  Future<Map<String, dynamic>> submitTeamCollaboration({
    required List<int> teamMemberIds,
    required String collaborationType,
    required Map<String, dynamic> results,
    required String token,
  }) async {
    return await submitGameAction(
      GameActionType.teamCollaboration,
      {
        'team_members': teamMemberIds,
        'collaboration_type': collaborationType,
        'results': results,
      },
      token,
    );
  }

  /// Get user's current rank position
  Future<Map<String, dynamic>> getUserRankPosition(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/rank'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load rank position: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading rank position: $e');
    }
  }

  /// Get nearby players for comparison
  Future<List<LeaderboardEntry>> getNearbyPlayers(String token, {int range = 5}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/nearby-players?range=$range'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> playersJson = data['data'] ?? [];
        return playersJson.map((json) => LeaderboardEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load nearby players: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading nearby players: $e');
    }
  }

  /// Get seasonal events and special challenges
  Future<List<Map<String, dynamic>>> getSeasonalEvents(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/game/seasonal-events'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load seasonal events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading seasonal events: $e');
    }
  }

  /// Submit feedback for gamification features
  Future<Map<String, dynamic>> submitGameFeedback({
    required String feature,
    required int rating,
    required String comments,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/game/feedback'),
        headers: ApiConstants.getAuthHeaders(token),
        body: json.encode({
          'feature': feature,
          'rating': rating,
          'comments': comments,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit feedback: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting feedback: $e');
    }
  }
}