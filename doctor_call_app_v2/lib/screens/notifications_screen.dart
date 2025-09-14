import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/realtime_provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات والتنبيهات'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<RealTimeProvider>(
            builder: (context, realTimeProvider, child) {
              return _buildConnectionStatus(realTimeProvider.connectionStatus);
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => _showClearAllDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notifications_active),
                  const SizedBox(width: 4),
                  StreamBuilder<NotificationData>(
                    stream: _notificationService.notifications,
                    builder: (context, snapshot) {
                      final unreadCount = _notificationService.unreadCount;
                      return Text(
                        'الكل ${unreadCount > 0 ? '($unreadCount)' : ''}',
                      );
                    },
                  ),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_hospital),
                  SizedBox(width: 4),
                  Text('المرضى'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 4),
                  Text('طوارئ'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.business),
                  SizedBox(width: 4),
                  Text('النظام'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotificationsTab(),
          _buildPatientNotificationsTab(),
          _buildEmergencyAlertsTab(),
          _buildSystemNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(WebSocketConnectionStatus status) {
    Color color;
    IconData icon;
    String tooltip;

    switch (status) {
      case WebSocketConnectionStatus.connected:
        color = Colors.green;
        icon = Icons.wifi;
        tooltip = 'متصل - التحديثات المباشرة نشطة';
        break;
      case WebSocketConnectionStatus.connecting:
        color = Colors.orange;
        icon = Icons.wifi_tethering;
        tooltip = 'جاري الاتصال...';
        break;
      case WebSocketConnectionStatus.disconnected:
        color = Colors.red;
        icon = Icons.wifi_off;
        tooltip = 'غير متصل - لا توجد تحديثات مباشرة';
        break;
      case WebSocketConnectionStatus.error:
        color = Colors.red;
        icon = Icons.error;
        tooltip = 'خطأ في الاتصال';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildAllNotificationsTab() {
    return StreamBuilder<NotificationData>(
      stream: _notificationService.notifications,
      builder: (context, snapshot) {
        final notifications = _notificationService.allNotifications;

        if (notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'لا توجد إشعارات',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
        );
      },
    );
  }

  Widget _buildPatientNotificationsTab() {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        final notifications = _notificationService.allNotifications
            .where((n) => n.type == NotificationType.patientUpdate)
            .toList();

        if (notifications.isEmpty) {
          return const Center(child: Text('لا توجد تحديثات للمرضى'));
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
        );
      },
    );
  }

  Widget _buildEmergencyAlertsTab() {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        final emergencyAlerts = realTimeProvider.emergencyAlerts;
        final emergencyNotifications = _notificationService.allNotifications
            .where((n) => n.type == NotificationType.emergencyAlert)
            .toList();

        return Column(
          children: [
            // Real-time emergency alerts from WebSocket
            if (emergencyAlerts.isNotEmpty) ...[
              Container(
                color: Colors.red.withOpacity(0.1),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تنبيهات طوارئ حية',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...emergencyAlerts
                        .take(3)
                        .map((alert) => _buildEmergencyAlertCard(alert)),
                  ],
                ),
              ),
              const Divider(),
            ],

            // Historical emergency notifications
            Expanded(
              child: emergencyNotifications.isEmpty
                  ? const Center(child: Text('لا توجد تنبيهات طوارئ'))
                  : ListView.builder(
                      itemCount: emergencyNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = emergencyNotifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSystemNotificationsTab() {
    return Consumer<RealTimeProvider>(
      builder: (context, realTimeProvider, child) {
        final systemMessages = realTimeProvider.systemMessages;
        final systemNotifications = _notificationService.allNotifications
            .where((n) => n.type == NotificationType.systemNotification)
            .toList();

        return Column(
          children: [
            // Real-time system messages
            if (systemMessages.isNotEmpty) ...[
              Container(
                color: Colors.blue.withOpacity(0.1),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'رسائل النظام الحية',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...systemMessages
                        .take(3)
                        .map((message) => _buildSystemMessageCard(message)),
                  ],
                ),
              ),
              const Divider(),
            ],

            // Historical system notifications
            Expanded(
              child: systemNotifications.isEmpty
                  ? const Center(child: Text('لا توجد رسائل نظام'))
                  : ListView.builder(
                      itemCount: systemNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = systemNotifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationCard(NotificationData notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _getNotificationIcon(notification.type),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            Text(
              _formatTime(notification.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          if (!notification.isRead) {
            _notificationService.markAsRead(notification.id);
            setState(() {});
          }
          _handleNotificationTap(notification);
        },
      ),
    );
  }

  Widget _buildEmergencyAlertCard(Map<String, dynamic> alert) {
    return Card(
      color: Colors.red.withOpacity(0.1),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text(
          alert['message'] ?? 'تنبيه طارئ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _formatTime(DateTime.parse(alert['timestamp'])),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _handleEmergencyAlertTap(alert),
      ),
    );
  }

  Widget _buildSystemMessageCard(Map<String, dynamic> message) {
    return Card(
      color: Colors.blue.withOpacity(0.1),
      child: ListTile(
        leading: const Icon(Icons.info, color: Colors.blue),
        title: Text(
          message['title'] ?? message['message'] ?? 'رسالة نظام',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _formatTime(DateTime.parse(message['timestamp'])),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _handleSystemMessageTap(message),
      ),
    );
  }

  Widget _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.patientUpdate:
        return const Icon(Icons.local_hospital, color: Colors.blue);
      case NotificationType.emergencyAlert:
        return const Icon(Icons.warning, color: Colors.red);
      case NotificationType.hospitalCapacity:
        return const Icon(Icons.business, color: Colors.orange);
      case NotificationType.systemNotification:
        return const Icon(Icons.info, color: Colors.grey);
      case NotificationType.gameAchievement:
        return const Icon(Icons.emoji_events, color: Colors.gold);
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  void _handleNotificationTap(NotificationData notification) {
    // Handle navigation based on notification type and payload
    switch (notification.type) {
      case NotificationType.patientUpdate:
        if (notification.payload?['patient_id'] != null) {
          // Navigate to patient details
          // Navigator.pushNamed(context, '/patient/${notification.payload!['patient_id']}');
        }
        break;
      case NotificationType.hospitalCapacity:
        if (notification.payload?['hospital_id'] != null) {
          // Navigate to hospital details
          // Navigator.pushNamed(context, '/hospital/${notification.payload!['hospital_id']}');
        }
        break;
      case NotificationType.emergencyAlert:
        // Show emergency details
        _showEmergencyDetails(notification.payload ?? {});
        break;
      default:
        break;
    }
  }

  void _handleEmergencyAlertTap(Map<String, dynamic> alert) {
    _showEmergencyDetails(alert);
  }

  void _handleSystemMessageTap(Map<String, dynamic> message) {
    _showSystemMessageDetails(message);
  }

  void _showEmergencyDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفاصيل التنبيه الطارئ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الرسالة: ${data['message'] ?? 'غير محدد'}'),
            Text('الشدة: ${data['severity'] ?? 'غير محدد'}'),
            if (data['patient_id'] != null)
              Text('رقم المريض: ${data['patient_id']}'),
            if (data['hospital_id'] != null)
              Text('رقم المستشفى: ${data['hospital_id']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showSystemMessageDetails(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data['title'] ?? 'رسالة النظام'),
        content: Text(data['message'] ?? data['body'] ?? 'لا توجد تفاصيل'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح جميع الإشعارات'),
        content: const Text('هل أنت متأكد من رغبتك في مسح جميع الإشعارات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              _notificationService.clearAll();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('مسح الكل'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
