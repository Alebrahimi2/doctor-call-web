import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:doctor_call_app_v2/core/providers/auth_provider.dart';
import 'package:doctor_call_app_v2/core/services/auth_service.dart';
import 'package:doctor_call_app_v2/core/models/user_model.dart';
import '../mocks/mock_data.dart';

// Generate mock classes
@GenerateMocks([AuthService])
import 'auth_provider_test.mocks.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      authProvider = AuthProvider();
      // Inject mock service into provider
      authProvider.authService = mockAuthService;
    });

    group('initialization', () {
      test('should initialize with default values', () {
        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.token, null);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
      });
    });

    group('login', () {
      test('should login successfully with valid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final mockResponse = MockData.mockLoginResponse;

        when(
          mockAuthService.login(email, password),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.login(email, password);

        // Assert
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.currentUser, isNotNull);
        expect(authProvider.currentUser!.email, email);
        expect(authProvider.token, mockResponse['data']['token']);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);

        verify(mockAuthService.login(email, password)).called(1);
      });

      test('should handle invalid credentials', () async {
        // Arrange
        const email = 'invalid@example.com';
        const password = 'wrongpassword';
        final mockResponse = MockData.mockUnauthorizedError;

        when(
          mockAuthService.login(email, password),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.login(email, password);

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.token, null);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, mockResponse['message']);
      });

      test('should set loading state during login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final mockResponse = MockData.mockLoginResponse;

        when(mockAuthService.login(email, password)).thenAnswer((_) async {
          // Simulate delay
          await Future.delayed(Duration(milliseconds: 100));
          return mockResponse;
        });

        // Act
        final loginFuture = authProvider.login(email, password);

        // Assert loading state
        expect(authProvider.isLoading, true);

        await loginFuture;

        // Assert final state
        expect(authProvider.isLoading, false);
      });

      test('should handle network errors', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockAuthService.login(email, password),
        ).thenThrow(Exception('Network error'));

        // Act
        await authProvider.login(email, password);

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.error, contains('Network error'));
        expect(authProvider.isLoading, false);
      });

      test('should validate email format', () async {
        // Arrange
        const invalidEmail = 'invalid-email';
        const password = 'password123';

        // Act
        await authProvider.login(invalidEmail, password);

        // Assert
        expect(
          authProvider.error,
          contains('صيغة البريد الإلكتروني غير صحيحة'),
        );
        expect(authProvider.isAuthenticated, false);

        // Should not call service with invalid email
        verifyNever(mockAuthService.login(any, any));
      });

      test('should validate password length', () async {
        // Arrange
        const email = 'test@example.com';
        const shortPassword = '123';

        // Act
        await authProvider.login(email, shortPassword);

        // Assert
        expect(authProvider.error, contains('كلمة المرور قصيرة جداً'));
        expect(authProvider.isAuthenticated, false);

        // Should not call service with short password
        verifyNever(mockAuthService.login(any, any));
      });
    });

    group('register', () {
      test('should register new user successfully', () async {
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
          mockAuthService.register(userData),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.register(userData);

        // Assert
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.currentUser, isNotNull);
        expect(authProvider.token, mockResponse['data']['token']);
        expect(authProvider.error, null);

        verify(mockAuthService.register(userData)).called(1);
      });

      test('should handle registration validation errors', () async {
        // Arrange
        final userData = {
          'name': 'د. أحمد محمد',
          'email': 'existing@example.com',
          'password': 'password123',
        };

        final mockResponse = MockData.mockValidationError;

        when(
          mockAuthService.register(userData),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.register(userData);

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.error, isNotNull);
        expect(authProvider.validationErrors, isNotNull);
      });
    });

    group('logout', () {
      test('should logout successfully', () async {
        // Arrange
        // First login to have a token
        authProvider.token = 'valid_token_123';
        authProvider.currentUser = MockData.mockUser;
        authProvider.isAuthenticated = true;

        final mockResponse = {
          'success': true,
          'message': 'تم تسجيل الخروج بنجاح',
        };

        when(
          mockAuthService.logout('valid_token_123'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.logout();

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.token, null);
        expect(authProvider.error, null);

        verify(mockAuthService.logout('valid_token_123')).called(1);
      });

      test('should handle logout when not authenticated', () async {
        // Arrange
        authProvider.isAuthenticated = false;
        authProvider.token = null;

        // Act
        await authProvider.logout();

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.token, null);

        // Should not call service when not authenticated
        verifyNever(mockAuthService.logout(any));
      });
    });

    group('updateProfile', () {
      test('should update user profile successfully', () async {
        // Arrange
        authProvider.token = 'valid_token_123';
        authProvider.currentUser = MockData.mockUser;
        authProvider.isAuthenticated = true;

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
          mockAuthService.updateProfile('valid_token_123', updateData),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.updateProfile(updateData);

        // Assert
        expect(authProvider.currentUser!.name, updateData['name']);
        expect(authProvider.error, null);

        verify(
          mockAuthService.updateProfile('valid_token_123', updateData),
        ).called(1);
      });

      test('should handle update when not authenticated', () async {
        // Arrange
        authProvider.isAuthenticated = false;
        final updateData = {'name': 'New Name'};

        // Act
        await authProvider.updateProfile(updateData);

        // Assert
        expect(authProvider.error, contains('غير مسجل'));

        // Should not call service when not authenticated
        verifyNever(mockAuthService.updateProfile(any, any));
      });
    });

    group('changePassword', () {
      test('should change password successfully', () async {
        // Arrange
        authProvider.token = 'valid_token_123';
        authProvider.isAuthenticated = true;

        const currentPassword = 'oldpassword';
        const newPassword = 'newpassword123';

        final mockResponse = {
          'success': true,
          'message': 'تم تغيير كلمة المرور بنجاح',
        };

        when(
          mockAuthService.changePassword(
            'valid_token_123',
            currentPassword,
            newPassword,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.changePassword(currentPassword, newPassword);

        // Assert
        expect(authProvider.error, null);
        expect(authProvider.passwordChangeSuccess, true);

        verify(
          mockAuthService.changePassword(
            'valid_token_123',
            currentPassword,
            newPassword,
          ),
        ).called(1);
      });

      test('should handle incorrect current password', () async {
        // Arrange
        authProvider.token = 'valid_token_123';
        authProvider.isAuthenticated = true;

        const currentPassword = 'wrongpassword';
        const newPassword = 'newpassword123';

        final mockResponse = {
          'success': false,
          'message': 'كلمة المرور الحالية غير صحيحة',
          'error_code': 400,
        };

        when(
          mockAuthService.changePassword(
            'valid_token_123',
            currentPassword,
            newPassword,
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.changePassword(currentPassword, newPassword);

        // Assert
        expect(authProvider.error, contains('كلمة المرور الحالية غير صحيحة'));
        expect(authProvider.passwordChangeSuccess, false);
      });
    });

    group('getCurrentUser', () {
      test('should refresh user data successfully', () async {
        // Arrange
        authProvider.token = 'valid_token_123';
        authProvider.isAuthenticated = true;

        final mockResponse = {
          'success': true,
          'data': MockData.mockUser.toJson(),
        };

        when(
          mockAuthService.getCurrentUser('valid_token_123'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.getCurrentUser();

        // Assert
        expect(authProvider.currentUser, isNotNull);
        expect(authProvider.currentUser!.id, MockData.mockUser.id);
        expect(authProvider.error, null);

        verify(mockAuthService.getCurrentUser('valid_token_123')).called(1);
      });

      test('should handle invalid token', () async {
        // Arrange
        authProvider.token = 'invalid_token';
        authProvider.isAuthenticated = true;

        final mockResponse = MockData.mockUnauthorizedError;

        when(
          mockAuthService.getCurrentUser('invalid_token'),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.getCurrentUser();

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.token, null);
      });
    });

    group('auto-login', () {
      test('should auto-login with stored token', () async {
        // Arrange
        const storedToken = 'stored_token_123';
        final mockResponse = {
          'success': true,
          'data': MockData.mockUser.toJson(),
        };

        when(
          mockAuthService.getCurrentUser(storedToken),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.autoLogin(storedToken);

        // Assert
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.currentUser, isNotNull);
        expect(authProvider.token, storedToken);
      });

      test('should handle invalid stored token', () async {
        // Arrange
        const invalidToken = 'invalid_stored_token';
        final mockResponse = MockData.mockUnauthorizedError;

        when(
          mockAuthService.getCurrentUser(invalidToken),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.autoLogin(invalidToken);

        // Assert
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
        expect(authProvider.token, null);
      });
    });

    group('state management', () {
      test('should notify listeners when state changes', () {
        // Arrange
        var notificationCount = 0;
        authProvider.addListener(() {
          notificationCount++;
        });

        // Act
        authProvider.setLoading(true);
        authProvider.setError('Test error');
        authProvider.clearError();

        // Assert
        expect(notificationCount, 3);
      });

      test('should clear error when setting loading', () {
        // Arrange
        authProvider.setError('Previous error');

        // Act
        authProvider.setLoading(true);

        // Assert
        expect(authProvider.error, null);
        expect(authProvider.isLoading, true);
      });

      test('should validate input data', () {
        // Test email validation
        expect(authProvider.isValidEmail('test@example.com'), true);
        expect(authProvider.isValidEmail('invalid-email'), false);
        expect(authProvider.isValidEmail(''), false);

        // Test password validation
        expect(authProvider.isValidPassword('password123'), true);
        expect(authProvider.isValidPassword('123'), false);
        expect(authProvider.isValidPassword(''), false);

        // Test name validation
        expect(authProvider.isValidName('د. أحمد محمد'), true);
        expect(authProvider.isValidName(''), false);
        expect(authProvider.isValidName('A'), false);
      });
    });

    group('error handling', () {
      test('should handle service exceptions gracefully', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(
          mockAuthService.login(email, password),
        ).thenThrow(Exception('Service error'));

        // Act
        await authProvider.login(email, password);

        // Assert
        expect(authProvider.error, isNotNull);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.isLoading, false);
      });

      test('should reset error state on successful operations', () async {
        // Arrange
        authProvider.setError('Previous error');
        const email = 'test@example.com';
        const password = 'password123';
        final mockResponse = MockData.mockLoginResponse;

        when(
          mockAuthService.login(email, password),
        ).thenAnswer((_) async => mockResponse);

        // Act
        await authProvider.login(email, password);

        // Assert
        expect(authProvider.error, null);
        expect(authProvider.isAuthenticated, true);
      });
    });
  });
}
