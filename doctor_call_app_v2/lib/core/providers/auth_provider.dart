import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _error;
  bool _isLoading = false;
  
  // Getters
  AuthState get state => _state;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated && _user != null;
  
  // Initialize auth state
  Future<void> initializeAuth() async {
    _setState(AuthState.loading);
    
    try {
      // Check if user has stored authentication
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          _user = user;
          _setState(AuthState.authenticated);
          return;
        }
      }
      
      // Try to get stored user data
      final storedUser = await _authService.getStoredUser();
      if (storedUser != null) {
        _user = storedUser;
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Failed to initialize authentication: $e');
    }
  }
  
  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.login(email, password);
      
      if (result.success && result.user != null) {
        _user = result.user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError(result.error ?? 'Login failed');
        return false;
      }
    } catch (e) {
      _setError('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? role,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        role: role,
      );
      
      if (result.success && result.user != null) {
        _user = result.user;
        _setState(AuthState.authenticated);
        return true;
      } else {
        _setError(result.error ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authService.logout();
    } catch (e) {
      // Continue with logout even if server request fails
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      _user = null;
      _setState(AuthState.unauthenticated);
      _setLoading(false);
    }
  }
  
  // Update profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        avatar: avatar,
      );
      
      if (result.success && result.user != null) {
        _user = result.user;
        notifyListeners();
        return true;
      } else {
        _setError(result.error ?? 'Profile update failed');
        return false;
      }
    } catch (e) {
      _setError('Profile update error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        passwordConfirmation: passwordConfirmation,
      );
      
      if (success) {
        return true;
      } else {
        _setError('Password change failed');
        return false;
      }
    } catch (e) {
      _setError('Password change error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Refresh current user data
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;
    
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _user = user;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Refresh user error: $e');
      }
    }
  }
  
  // Private helper methods
  void _setState(AuthState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
  
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
  
  void _setError(String error) {
    _error = error;
    _setState(AuthState.error);
  }
  
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
  
  // Clear all data (useful for testing or complete reset)
  void clearAll() {
    _user = null;
    _error = null;
    _isLoading = false;
    _setState(AuthState.initial);
  }
}