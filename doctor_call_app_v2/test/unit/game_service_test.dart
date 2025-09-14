import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:doctor_call_app_v2/core/services/game_service.dart';
import 'package:doctor_call_app_v2/core/models/game_score_model.dart';
import 'package:doctor_call_app_v2/core/models/achievement_model.dart';
import '../mocks/mock_data.dart';

// Generate mock classes
@GenerateMocks([http.Client])
import 'game_service_test.mocks.dart';

void main() {
  group('GameService Tests', () {
    late GameService gameService;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      gameService = GameService();
      // Inject mock client into game service
    });

    group('getUserGameStats', () {
      test('should return user game statistics', () async {
        // Arrange
        const token = 'valid_token_123';
        const userId = 1;

        final mockResponse = {
          'success': true,
          'data': {
            'total_score': 1250,
            'total_patients': 45,
            'success_rate': 0.89,
            'streak_days': 7,
            'achievements_count': 12,
            'rank': 5,
            'recent_scores': MockData.mockGameScores
                .map((s) => s.toJson())
                .toList(),
          },
        };

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await gameService.getUserGameStats(token, userId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['total_score'], 1250);
        expect(result['data']['success_rate'], 0.89);
        expect(result['data']['recent_scores'], isA<List>());
      });

      test('should handle user not found', () async {
        // Arrange
        const token = 'valid_token_123';
        const userId = 999;

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(json.encode(MockData.mockNotFoundError), 404),
        );

        // Act
        final result = await gameService.getUserGameStats(token, userId);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 404);
      });
    });

    group('recordGameAction', () {
      test('should record game action successfully', () async {
        // Arrange
        const token = 'valid_token_123';
        final gameAction = {
          'patient_id': 1,
          'action_type': 'diagnosis',
          'action_value': 'الحمى الفيروسية',
          'response_time': 45,
          'is_correct': true,
        };

        final mockResponse = {
          'success': true,
          'message': 'تم تسجيل العمل بنجاح',
          'data': {
            'score_earned': 85,
            'total_score': 1335,
            'achievement_unlocked': null,
          },
        };

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 201),
        );

        // Act
        final result = await gameService.recordGameAction(token, gameAction);

        // Assert
        expect(result['success'], true);
        expect(result['data']['score_earned'], 85);
        expect(result['data']['total_score'], 1335);
      });

      test('should record game action with achievement unlock', () async {
        // Arrange
        const token = 'valid_token_123';
        final gameAction = {
          'patient_id': 1,
          'action_type': 'diagnosis',
          'action_value': 'الحمى الفيروسية',
          'response_time': 30,
          'is_correct': true,
        };

        final mockResponse = {
          'success': true,
          'message': 'تم تسجيل العمل بنجاح',
          'data': {
            'score_earned': 100,
            'total_score': 1350,
            'achievement_unlocked': MockData.mockAchievements.first.toJson(),
          },
        };

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 201),
        );

        // Act
        final result = await gameService.recordGameAction(token, gameAction);

        // Assert
        expect(result['success'], true);
        expect(result['data']['achievement_unlocked'], isNotNull);
        expect(
          result['data']['achievement_unlocked']['name'],
          MockData.mockAchievements.first.name,
        );
      });

      test('should handle incorrect diagnosis', () async {
        // Arrange
        const token = 'valid_token_123';
        final gameAction = {
          'patient_id': 1,
          'action_type': 'diagnosis',
          'action_value': 'تشخيص خاطئ',
          'response_time': 120,
          'is_correct': false,
        };

        final mockResponse = {
          'success': true,
          'message': 'تم تسجيل العمل',
          'data': {
            'score_earned': -10,
            'total_score': 1240,
            'achievement_unlocked': null,
            'correct_answer': 'الحمى الفيروسية',
          },
        };

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 201),
        );

        // Act
        final result = await gameService.recordGameAction(token, gameAction);

        // Assert
        expect(result['success'], true);
        expect(result['data']['score_earned'], -10);
        expect(result['data']['correct_answer'], isNotNull);
      });
    });

    group('getLeaderboard', () {
      test('should return leaderboard data', () async {
        // Arrange
        const token = 'valid_token_123';
        const page = 1;
        const limit = 10;

        final mockResponse = {
          'success': true,
          'data': {
            'current_page': 1,
            'total_pages': 5,
            'total_users': 47,
            'leaderboard': MockData.mockLeaderboard
                .map((entry) => entry.toJson())
                .toList(),
          },
        };

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await gameService.getLeaderboard(token, page, limit);

        // Assert
        expect(result['success'], true);
        expect(result['data']['leaderboard'], isA<List>());
        expect(result['data']['leaderboard'].length, greaterThan(0));
        expect(result['data']['current_page'], 1);
      });

      test('should handle empty leaderboard', () async {
        // Arrange
        const token = 'valid_token_123';
        const page = 10;
        const limit = 10;

        final mockResponse = {
          'success': true,
          'data': {
            'current_page': 10,
            'total_pages': 5,
            'total_users': 47,
            'leaderboard': [],
          },
        };

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await gameService.getLeaderboard(token, page, limit);

        // Assert
        expect(result['success'], true);
        expect(result['data']['leaderboard'], isEmpty);
      });
    });

    group('getUserAchievements', () {
      test('should return user achievements', () async {
        // Arrange
        const token = 'valid_token_123';
        const userId = 1;

        final mockResponse = {
          'success': true,
          'data': {
            'unlocked_achievements': MockData.mockAchievements
                .where((a) => a.isUnlocked)
                .map((a) => a.toJson())
                .toList(),
            'locked_achievements': MockData.mockAchievements
                .where((a) => !a.isUnlocked)
                .map((a) => a.toJson())
                .toList(),
            'total_points': 750,
            'completion_percentage': 0.6,
          },
        };

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await gameService.getUserAchievements(token, userId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['unlocked_achievements'], isA<List>());
        expect(result['data']['locked_achievements'], isA<List>());
        expect(result['data']['total_points'], 750);
      });
    });

    group('getDailyChallenges', () {
      test('should return daily challenges', () async {
        // Arrange
        const token = 'valid_token_123';

        final mockResponse = {
          'success': true,
          'data': {
            'challenges': [
              {
                'id': 1,
                'title': 'تشخيص سريع',
                'description': 'قم بتشخيص 5 حالات في أقل من دقيقة لكل حالة',
                'target': 5,
                'current_progress': 2,
                'reward_points': 100,
                'expires_at': '2024-01-15T23:59:59Z',
                'is_completed': false,
              },
              {
                'id': 2,
                'title': 'دقة عالية',
                'description': 'حقق دقة 95% أو أكثر في 10 تشخيصات',
                'target': 10,
                'current_progress': 7,
                'reward_points': 150,
                'expires_at': '2024-01-15T23:59:59Z',
                'is_completed': false,
              },
            ],
          },
        };

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await gameService.getDailyChallenges(token);

        // Assert
        expect(result['success'], true);
        expect(result['data']['challenges'], isA<List>());
        expect(result['data']['challenges'].length, 2);
      });
    });

    group('calculateScore', () {
      test('should calculate score for correct diagnosis', () {
        // Arrange
        const responseTime = 45; // seconds
        const isCorrect = true;
        const difficulty = 'medium';

        // Act
        final score = gameService.calculateScore(
          responseTime: responseTime,
          isCorrect: isCorrect,
          difficulty: difficulty,
        );

        // Assert
        expect(score, greaterThan(0));
        expect(score, lessThanOrEqualTo(100));
      });

      test('should return negative score for incorrect diagnosis', () {
        // Arrange
        const responseTime = 120; // seconds
        const isCorrect = false;
        const difficulty = 'easy';

        // Act
        final score = gameService.calculateScore(
          responseTime: responseTime,
          isCorrect: isCorrect,
          difficulty: difficulty,
        );

        // Assert
        expect(score, lessThan(0));
      });

      test('should give bonus for fast response', () {
        // Arrange
        const fastResponseTime = 20; // seconds
        const slowResponseTime = 90; // seconds
        const difficulty = 'medium';

        // Act
        final fastScore = gameService.calculateScore(
          responseTime: fastResponseTime,
          isCorrect: true,
          difficulty: difficulty,
        );

        final slowScore = gameService.calculateScore(
          responseTime: slowResponseTime,
          isCorrect: true,
          difficulty: difficulty,
        );

        // Assert
        expect(fastScore, greaterThan(slowScore));
      });

      test('should give higher score for difficult cases', () {
        // Arrange
        const responseTime = 60; // seconds

        // Act
        final easyScore = gameService.calculateScore(
          responseTime: responseTime,
          isCorrect: true,
          difficulty: 'easy',
        );

        final hardScore = gameService.calculateScore(
          responseTime: responseTime,
          isCorrect: true,
          difficulty: 'hard',
        );

        // Assert
        expect(hardScore, greaterThan(easyScore));
      });
    });

    group('checkAchievements', () {
      test('should detect new achievement unlock', () async {
        // Arrange
        const token = 'valid_token_123';
        final userStats = {
          'total_score': 1000,
          'total_patients': 50,
          'success_rate': 0.95,
          'streak_days': 7,
        };

        // Act
        final newAchievements = await gameService.checkAchievements(
          token,
          userStats,
        );

        // Assert
        expect(newAchievements, isA<List>());
        // Should contain achievements based on the stats
      });
    });

    group('error handling', () {
      test('should handle server errors gracefully', () async {
        // Arrange
        const token = 'valid_token_123';

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(json.encode(MockData.mockServerError), 500),
        );

        // Act
        final result = await gameService.getUserGameStats(token, 1);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 500);
      });

      test('should handle network timeouts', () async {
        // Arrange
        const token = 'valid_token_123';

        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenThrow(Exception('Timeout'));

        // Act
        final result = await gameService.getUserGameStats(token, 1);

        // Assert
        expect(result['success'], false);
        expect(result['message'], contains('Timeout'));
      });
    });
  });
}
