import 'dart:convert';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'websocket_service.dart';

enum NotificationType {
  patientUpdate,
  emergencyAlert,
  hospitalCapacity,
  systemNotification,
  gameAchievement,
}

class NotificationData {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final Map<String, dynamic>? payload;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final int? priority; // 1-5, 5 being highest

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.payload,
    DateTime? timestamp,
    this.isRead = false,
    this.imageUrl,
    this.priority = 3,
  }) : timestamp = timestamp ?? DateTime.now();

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.systemNotification,
      ),
      payload: json['payload'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
      imageUrl: json['image_url'],
      priority: json['priority'] ?? 3,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString().split('.').last,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'image_url': imageUrl,
      'priority': priority,
    };
  }

  NotificationData copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    Map<String, dynamic>? payload,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    int? priority,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      priority: priority ?? this.priority,
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final WebSocketService _webSocketService = WebSocketService();

  final StreamController<NotificationData> _notificationController =
      StreamController<NotificationData>.broadcast();
  final List<NotificationData> _notifications = [];

  StreamSubscription? _webSocketSubscription;
  bool _isInitialized = false;

  // Getters
  Stream<NotificationData> get notifications => _notificationController.stream;
  List<NotificationData> get allNotifications =>
      List.unmodifiable(_notifications);
  List<NotificationData> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Listen to WebSocket messages for real-time notifications
    _webSocketSubscription = _webSocketService.messages.listen(
      _handleWebSocketMessage,
    );

    _isInitialized = true;
  }

  /// Handle WebSocket messages and convert to notifications
  void _handleWebSocketMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'patient_update':
        _createPatientUpdateNotification(message);
        break;
      case 'emergency_alert':
        _createEmergencyNotification(message);
        break;
      case 'hospital_update':
        _createHospitalNotification(message);
        break;
      case 'notification':
        _createSystemNotification(message);
        break;
      case 'achievement':
        _createAchievementNotification(message);
        break;
    }
  }

  /// Create patient update notification
  void _createPatientUpdateNotification(Map<String, dynamic> data) {
    final notification = NotificationData(
      id: 'patient_${data['patient_id']}_${DateTime.now().millisecondsSinceEpoch}',
      title: 'تحديث حالة المريض',
      body:
          'تم تحديث حالة المريض ${data['patient_name']} إلى ${data['status']}',
      type: NotificationType.patientUpdate,
      payload: data,
      priority: _getPatientPriority(data['status']),
    );

    _addNotification(notification);
    _showLocalNotification(notification);
  }

  /// Create emergency alert notification
  void _createEmergencyNotification(Map<String, dynamic> data) {
    final notification = NotificationData(
      id: 'emergency_${DateTime.now().millisecondsSinceEpoch}',
      title: '🚨 تنبيه طارئ',
      body: data['message'] ?? 'حالة طوارئ تتطلب اهتماماً فورياً',
      type: NotificationType.emergencyAlert,
      payload: data,
      priority: 5, // Highest priority
    );

    _addNotification(notification);
    _showLocalNotification(notification);
  }

  /// Create hospital capacity notification
  void _createHospitalNotification(Map<String, dynamic> data) {
    final notification = NotificationData(
      id: 'hospital_${data['hospital_id']}_${DateTime.now().millisecondsSinceEpoch}',
      title: 'تحديث سعة المستشفى',
      body:
          'متاح الآن ${data['available_beds']} سرير في ${data['hospital_name']}',
      type: NotificationType.hospitalCapacity,
      payload: data,
      priority: 3,
    );

    _addNotification(notification);
    _showLocalNotification(notification);
  }

  /// Create system notification
  void _createSystemNotification(Map<String, dynamic> data) {
    final notification = NotificationData(
      id: 'system_${DateTime.now().millisecondsSinceEpoch}',
      title: data['title'] ?? 'إشعار النظام',
      body: data['body'] ?? data['message'] ?? '',
      type: NotificationType.systemNotification,
      payload: data,
      priority: data['priority'] ?? 3,
    );

    _addNotification(notification);
    _showLocalNotification(notification);
  }

  /// Create achievement notification
  void _createAchievementNotification(Map<String, dynamic> data) {
    final notification = NotificationData(
      id: 'achievement_${DateTime.now().millisecondsSinceEpoch}',
      title: '🏆 إنجاز جديد!',
      body: data['achievement_name'] ?? 'لقد حققت إنجازاً جديداً!',
      type: NotificationType.gameAchievement,
      payload: data,
      priority: 4,
    );

    _addNotification(notification);
    _showLocalNotification(notification);
  }

  /// Add notification to list and stream
  void _addNotification(NotificationData notification) {
    _notifications.insert(0, notification); // Add to top
    _notificationController.add(notification);

    // Keep only last 100 notifications
    if (_notifications.length > 100) {
      _notifications.removeRange(100, _notifications.length);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(NotificationData notification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'doctor_call_channel',
          'Doctor Call Notifications',
          channelDescription: 'Notifications for Doctor Call app',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: json.encode(notification.payload ?? {}),
    );
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final payload = json.decode(response.payload!);
        // Handle navigation based on notification type
        // This will be implemented in the UI layer
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  /// Clear all notifications
  void clearAll() {
    _notifications.clear();
    _localNotifications.cancelAll();
  }

  /// Clear notifications by type
  void clearByType(NotificationType type) {
    _notifications.removeWhere((n) => n.type == type);
  }

  /// Get patient priority based on status
  int _getPatientPriority(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return 5;
      case 'urgent':
        return 4;
      case 'stable':
        return 2;
      default:
        return 3;
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final android = await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    final ios = await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return android ?? ios ?? false;
  }

  /// Send custom notification (for testing or manual notifications)
  void sendCustomNotification({
    required String title,
    required String body,
    NotificationType type = NotificationType.systemNotification,
    Map<String, dynamic>? payload,
    int priority = 3,
  }) {
    final notification = NotificationData(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      type: type,
      payload: payload,
      priority: priority,
    );

    _addNotification(notification);
    _showLocalNotification(notification);
  }

  /// Dispose resources
  void dispose() {
    _webSocketSubscription?.cancel();
    _notificationController.close();
  }
}
