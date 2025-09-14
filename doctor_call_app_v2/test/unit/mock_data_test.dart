import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_data.dart';

void main() {
  group('Mock Data Tests', () {
    test('should have valid mock user', () {
      // Act
      final user = MockData.mockUser;

      // Assert
      expect(user.id, 1);
      expect(user.name, 'د. أحمد محمد');
      expect(user.email, 'ahmed@hospital.com');
    });

    test('should have valid mock patients', () {
      // Act
      final patients = MockData.mockPatients;

      // Assert
      expect(patients, isA<List>());
      expect(patients.length, greaterThan(0));
      expect(patients.first.name, contains('أحمد'));
    });

    test('should have valid mock hospitals', () {
      // Act
      final hospitals = MockData.mockHospitals;

      // Assert
      expect(hospitals, isA<List>());
      expect(hospitals.length, greaterThan(0));
      expect(hospitals.first.name, contains('الملك'));
    });

    test('should have valid mock game scores', () {
      // Act
      final scores = MockData.mockGameScores;

      // Assert
      expect(scores, isA<List>());
      expect(scores.length, greaterThan(0));
      expect(scores.first.score, greaterThan(0));
    });

    test('should have valid mock achievements', () {
      // Act
      final achievements = MockData.mockAchievements;

      // Assert
      expect(achievements, isA<List>());
      expect(achievements.length, greaterThan(0));
      expect(achievements.first.name, isNotEmpty);
    });

    test('should have valid API responses', () {
      // Act
      final loginResponse = MockData.mockLoginResponse;
      final errorResponse = MockData.mockUnauthorizedError;

      // Assert
      expect(loginResponse['success'], true);
      expect(loginResponse['data'], isNotNull);
      
      expect(errorResponse['success'], false);
      expect(errorResponse['error_code'], 401);
    });
  });
}