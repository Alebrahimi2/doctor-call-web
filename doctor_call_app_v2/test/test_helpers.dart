import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:doctor_call_app_v2/core/providers/auth_provider.dart';
import 'package:doctor_call_app_v2/core/providers/game_provider.dart';
import 'package:doctor_call_app_v2/core/providers/realtime_provider.dart';
import 'mock_data.dart';

class TestHelpers {
  /// Creates a widget wrapped with all necessary providers for testing
  static Widget createTestWidget({
    required Widget child,
    AuthProvider? authProvider,
    GameProvider? gameProvider,
    RealTimeProvider? realTimeProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider ?? MockAuthProvider(),
        ),
        ChangeNotifierProvider<GameProvider>(
          create: (_) => gameProvider ?? MockGameProvider(),
        ),
        ChangeNotifierProvider<RealTimeProvider>(
          create: (_) => realTimeProvider ?? MockRealTimeProvider(),
        ),
      ],
      child: MaterialApp(
        home: child,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
      ),
    );
  }

  /// Creates a minimal MaterialApp for widget testing
  static Widget createMaterialApp({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }

  /// Pumps a widget and waits for animations to complete
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Finds a widget by its key
  static Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Finds a text widget
  static Finder findText(String text) {
    return find.text(text);
  }

  /// Finds a widget by its type
  static Finder findByType<T>() {
    return find.byType(T);
  }

  /// Taps a widget and waits for the action to complete
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enters text into a text field
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Scrolls a widget into view
  static Future<void> scrollIntoView(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(finder, 100.0);
    await tester.pumpAndSettle();
  }

  /// Waits for a specific condition to be true
  static Future<void> waitFor(
    WidgetTester tester,
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final stopwatch = Stopwatch()..start();
    while (!condition() && stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    if (!condition()) {
      throw TimeoutException('Condition not met within timeout', timeout);
    }
  }

  /// Verifies that a widget exists
  static void expectToFind(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Verifies that a widget does not exist
  static void expectNotToFind(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verifies that multiple widgets exist
  static void expectToFindMultiple(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }
}

/// Mock AuthProvider for testing
class MockAuthProvider extends AuthProvider {
  bool _isAuthenticated = false;
  bool _isLoading = false;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  bool get isLoading => _isLoading;

  @override
  User? get user => _isAuthenticated ? MockData.mockUser : null;

  @override
  String? get token => _isAuthenticated ? 'mock_token_123' : null;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  Future<bool> login(String email, String password) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (email == 'test@example.com' && password == 'password') {
      setAuthenticated(true);
      setLoading(false);
      return true;
    }

    setLoading(false);
    return false;
  }

  @override
  Future<bool> register(Map<String, dynamic> userData) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 500));
    setAuthenticated(true);
    setLoading(false);
    return true;
  }

  @override
  Future<void> logout() async {
    setAuthenticated(false);
  }
}

/// Mock GameProvider for testing
class MockGameProvider extends GameProvider {
  bool _isLoading = false;
  GameScore? _currentScore;
  List<Achievement> _achievements = [];
  List<LeaderboardEntry> _leaderboard = [];

  @override
  bool get isLoadingScore => _isLoading;

  @override
  bool get isLoadingAchievements => _isLoading;

  @override
  bool get isLoadingLeaderboard => _isLoading;

  @override
  GameScore? get currentScore => _currentScore;

  @override
  List<Achievement> get allAchievements => _achievements;

  @override
  List<Achievement> get userAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  @override
  List<LeaderboardEntry> get leaderboard => _leaderboard;

  @override
  int get totalUnlockedAchievements => userAchievements.length;

  @override
  int get totalAvailableAchievements => _achievements.length;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setMockData() {
    _currentScore = MockData.mockGameScore;
    _achievements = MockData.mockAchievements;
    _leaderboard = MockData.mockLeaderboard;
    notifyListeners();
  }

  @override
  Future<void> loadUserScore(String token) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    _currentScore = MockData.mockGameScore;
    setLoading(false);
  }

  @override
  Future<void> loadAchievements(String token) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    _achievements = MockData.mockAchievements;
    setLoading(false);
  }

  @override
  Future<void> loadLeaderboard(
    String token, {
    String category = 'overall',
  }) async {
    setLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    _leaderboard = MockData.mockLeaderboard;
    setLoading(false);
  }
}

/// Mock RealTimeProvider for testing
class MockRealTimeProvider extends RealTimeProvider {
  bool _isConnected = false;
  List<Map<String, dynamic>> _notifications = [];

  @override
  bool get isConnected => _isConnected;

  @override
  List<Map<String, dynamic>> get notifications => _notifications;

  @override
  int get unreadCount => _notifications.where((n) => !n['read']).length;

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  void addMockNotification(Map<String, dynamic> notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  @override
  Future<void> connect(String token) async {
    await Future.delayed(const Duration(milliseconds: 200));
    setConnected(true);
  }

  @override
  void disconnect() {
    setConnected(false);
  }

  @override
  void markAsRead(int notificationId) {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['read'] = true;
      notifyListeners();
    }
  }
}

/// Custom exception for test timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}
