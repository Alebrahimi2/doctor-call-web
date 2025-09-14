import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../constants/api_constants.dart';

enum WebSocketConnectionStatus {
  connecting,
  connected,
  disconnected,
  error,
}

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<WebSocketConnectionStatus> _statusController = 
      StreamController<WebSocketConnectionStatus>.broadcast();

  WebSocketConnectionStatus _status = WebSocketConnectionStatus.disconnected;
  String? _token;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  static const Duration reconnectDelay = Duration(seconds: 5);
  static const Duration heartbeatInterval = Duration(seconds: 30);

  // Getters
  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  Stream<WebSocketConnectionStatus> get connectionStatus => _statusController.stream;
  WebSocketConnectionStatus get currentStatus => _status;
  bool get isConnected => _status == WebSocketConnectionStatus.connected;

  /// Connect to WebSocket server with authentication token
  Future<void> connect(String token) async {
    try {
      _token = token;
      _updateStatus(WebSocketConnectionStatus.connecting);
      
      // Construct WebSocket URL with auth token
      final wsUrl = '${ApiConstants.wsBaseUrl}/ws?token=$token';
      
      // Create WebSocket connection
      _channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Listen to WebSocket messages
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
      );

      _updateStatus(WebSocketConnectionStatus.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();
      
      // Send initial connection message
      _sendMessage({
        'type': 'connection',
        'action': 'subscribe',
        'channels': ['patients', 'hospitals', 'emergency', 'notifications']
      });

    } catch (e) {
      _updateStatus(WebSocketConnectionStatus.error);
      _scheduleReconnect();
    }
  }

  /// Disconnect from WebSocket server
  void disconnect() {
    _stopHeartbeat();
    _stopReconnectTimer();
    _subscription?.cancel();
    _channel?.sink.close();
    _updateStatus(WebSocketConnectionStatus.disconnected);
  }

  /// Send message to WebSocket server
  void _sendMessage(Map<String, dynamic> message) {
    if (isConnected && _channel != null) {
      _channel!.sink.add(json.encode(message));
    }
  }

  /// Subscribe to specific patient updates
  void subscribeToPatient(int patientId) {
    _sendMessage({
      'type': 'subscribe',
      'channel': 'patient',
      'patient_id': patientId,
    });
  }

  /// Unsubscribe from specific patient updates
  void unsubscribeFromPatient(int patientId) {
    _sendMessage({
      'type': 'unsubscribe',
      'channel': 'patient',
      'patient_id': patientId,
    });
  }

  /// Subscribe to hospital updates
  void subscribeToHospital(int hospitalId) {
    _sendMessage({
      'type': 'subscribe',
      'channel': 'hospital',
      'hospital_id': hospitalId,
    });
  }

  /// Subscribe to emergency alerts
  void subscribeToEmergencyAlerts() {
    _sendMessage({
      'type': 'subscribe',
      'channel': 'emergency',
    });
  }

  /// Send patient status update
  void sendPatientStatusUpdate(int patientId, String status) {
    _sendMessage({
      'type': 'patient_update',
      'patient_id': patientId,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Send emergency alert
  void sendEmergencyAlert(Map<String, dynamic> alertData) {
    _sendMessage({
      'type': 'emergency_alert',
      'data': alertData,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Send hospital capacity update
  void sendHospitalCapacityUpdate(int hospitalId, int availableBeds) {
    _sendMessage({
      'type': 'hospital_update',
      'hospital_id': hospitalId,
      'available_beds': availableBeds,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Handle incoming WebSocket messages
  void _onMessage(dynamic message) {
    try {
      final Map<String, dynamic> data = json.decode(message);
      _messageController.add(data);
      
      // Handle specific message types
      switch (data['type']) {
        case 'heartbeat':
          _sendMessage({'type': 'heartbeat_response'});
          break;
        case 'patient_update':
          // Patient status changed
          break;
        case 'hospital_update':
          // Hospital capacity changed
          break;
        case 'emergency_alert':
          // Emergency situation
          break;
        case 'notification':
          // General notification
          break;
      }
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  /// Handle WebSocket errors
  void _onError(error) {
    print('WebSocket error: $error');
    _updateStatus(WebSocketConnectionStatus.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _onDisconnected() {
    print('WebSocket disconnected');
    _updateStatus(WebSocketConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  /// Update connection status
  void _updateStatus(WebSocketConnectionStatus status) {
    _status = status;
    _statusController.add(status);
  }

  /// Start heartbeat to keep connection alive
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(heartbeatInterval, (timer) {
      if (isConnected) {
        _sendMessage({'type': 'heartbeat'});
      }
    });
  }

  /// Stop heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (_reconnectAttempts < maxReconnectAttempts && _token != null) {
      _stopReconnectTimer();
      _reconnectTimer = Timer(reconnectDelay, () async {
        _reconnectAttempts++;
        print('Reconnection attempt $_reconnectAttempts');
        await connect(_token!);
      });
    }
  }

  /// Stop reconnection timer
  void _stopReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _statusController.close();
  }
}

/// WebSocket message types for type safety
class WebSocketMessageType {
  static const String connection = 'connection';
  static const String subscribe = 'subscribe';
  static const String unsubscribe = 'unsubscribe';
  static const String patientUpdate = 'patient_update';
  static const String hospitalUpdate = 'hospital_update';
  static const String emergencyAlert = 'emergency_alert';
  static const String notification = 'notification';
  static const String heartbeat = 'heartbeat';
  static const String heartbeatResponse = 'heartbeat_response';
}

/// WebSocket channels for organization
class WebSocketChannel {
  static const String patients = 'patients';
  static const String hospitals = 'hospitals';
  static const String emergency = 'emergency';
  static const String notifications = 'notifications';
  static const String patient = 'patient';
  static const String hospital = 'hospital';
}