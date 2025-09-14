import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:doctor_call_app_v2/core/services/auth_service.dart';
import 'package:doctor_call_app_v2/core/models/user_model.dart';
import '../mocks/mock_data.dart';

// Generate mock classes
@GenerateMocks([http.Client])
import 'auth_service_test.mocks.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      authService = AuthService();
      // Inject mock client into auth service
      // Note: This would require modifying AuthService to accept an HTTP client
    });

    group('login', () {
      test('should return user and token on successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        final mockResponse = MockData.mockLoginResponse;

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await authService.login(email, password);

        // Assert
        expect(result['success'], true);
        expect(result['data']['user']['email'], email);
        expect(result['data']['token'], isNotNull);

        // Verify the HTTP call was made with correct parameters
        verify(
          mockHttpClient.post(
            any,
            headers: argThat(contains('Content-Type'), named: 'headers'),
            body: argThat(contains('"email":"$email"'), named: 'body'),
          ),
        ).called(1);
      });

      test('should return error on invalid credentials', () async {
        // Arrange
        const email = 'invalid@example.com';
        const password = 'wrongpassword';

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(json.encode(MockData.mockUnauthorizedError), 401),
        );

        // Act
        final result = await authService.login(email, password);

        // Assert
        expect(result['success'], false);
        expect(result['message'], 'Unauthorized');
        expect(result['error_code'], 401);
      });

      test('should handle network errors gracefully', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenThrow(Exception('Network error'));

        // Act
        final result = await authService.login(email, password);

        // Assert
        expect(result['success'], false);
        expect(result['message'], contains('Network'));
      });

      test('should handle validation errors', () async {
        // Arrange
        const email = '';
        const password = '123';

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(json.encode(MockData.mockValidationError), 422),
        );

        // Act
        final result = await authService.login(email, password);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 422);
        expect(result['errors'], isNotNull);
      });
    });

    group('register', () {
      test('should register user successfully', () async {
        // Arrange
        final userData = {
          'name': 'د. أحمد محمد',
          'email': 'ahmed@example.com',
          'password': 'password123',
          'hospital_id': 1,
          'role': 'doctor',
        };

        final mockResponse = {
          'success': true,
          'message': 'تم إنشاء الحساب بنجاح',
          'data': {
            'user': MockData.mockUser.toJson(),
            'token': 'new_token_123456789',
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
        final result = await authService.register(userData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['user']['name'], userData['name']);
        expect(result['data']['token'], isNotNull);
      });

      test('should handle duplicate email error', () async {
        // Arrange
        final userData = {
          'name': 'د. أحمد محمد',
          'email': 'existing@example.com',
          'password': 'password123',
        };

        final mockResponse = {
          'success': false,
          'message': 'Validation failed',
          'errors': {
            'email': ['The email has already been taken.'],
          },
          'error_code': 422,
        };

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 422),
        );

        // Act
        final result = await authService.register(userData);

        // Assert
        expect(result['success'], false);
        expect(result['errors']['email'], contains('already been taken'));
      });
    });

    group('logout', () {
      test('should logout successfully', () async {
        // Arrange
        const token = 'valid_token_123';

        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
            json.encode({'success': true, 'message': 'تم تسجيل الخروج بنجاح'}),
            200,
          ),
        );

        // Act
        final result = await authService.logout(token);

        // Assert
        expect(result['success'], true);

        // Verify the Authorization header was included
        verify(
          mockHttpClient.post(
            any,
            headers: argThat(contains('Authorization'), named: 'headers'),
          ),
        ).called(1);
      });

      test('should handle unauthorized logout', () async {
        // Arrange
        const token = 'invalid_token';

        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(json.encode(MockData.mockUnauthorizedError), 401),
        );

        // Act
        final result = await authService.logout(token);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 401);
      });
    });

    group('getCurrentUser', () {
      test('should return user profile when token is valid', () async {
        // Arrange
        const token = 'valid_token_123';

        final mockResponse = {
          'success': true,
          'data': MockData.mockUser.toJson(),
        };

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await authService.getCurrentUser(token);

        // Assert
        expect(result['success'], true);
        expect(result['data']['id'], MockData.mockUser.id);
        expect(result['data']['email'], MockData.mockUser.email);
      });

      test('should return error when token is invalid', () async {
        // Arrange
        const token = 'invalid_token';

        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(json.encode(MockData.mockUnauthorizedError), 401),
        );

        // Act
        final result = await authService.getCurrentUser(token);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 401);
      });
    });

    group('updateProfile', () {
      test('should update user profile successfully', () async {
        // Arrange
        const token = 'valid_token_123';
        final updateData = {
          'name': 'د. أحمد محمد الجديد',
          'phone': '+966501234567',
        };

        final updatedUser = MockData.mockUser;
        updatedUser.name = updateData['name']!;

        final mockResponse = {
          'success': true,
          'message': 'تم تحديث الملف الشخصي بنجاح',
          'data': updatedUser.toJson(),
        };

        when(
          mockHttpClient.put(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await authService.updateProfile(token, updateData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['name'], updateData['name']);
      });
    });

    group('changePassword', () {
      test('should change password successfully', () async {
        // Arrange
        const token = 'valid_token_123';
        const currentPassword = 'oldpassword';
        const newPassword = 'newpassword123';

        final mockResponse = {
          'success': true,
          'message': 'تم تغيير كلمة المرور بنجاح',
        };

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 200),
        );

        // Act
        final result = await authService.changePassword(
          token,
          currentPassword,
          newPassword,
        );

        // Assert
        expect(result['success'], true);
        expect(result['message'], contains('تم تغيير كلمة المرور'));
      });

      test('should reject incorrect current password', () async {
        // Arrange
        const token = 'valid_token_123';
        const currentPassword = 'wrongpassword';
        const newPassword = 'newpassword123';

        final mockResponse = {
          'success': false,
          'message': 'كلمة المرور الحالية غير صحيحة',
          'error_code': 400,
        };

        when(
          mockHttpClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode(mockResponse), 400),
        );

        // Act
        final result = await authService.changePassword(
          token,
          currentPassword,
          newPassword,
        );

        // Assert
        expect(result['success'], false);
        expect(result['message'], contains('كلمة المرور الحالية غير صحيحة'));
      });
    });
  });
}
