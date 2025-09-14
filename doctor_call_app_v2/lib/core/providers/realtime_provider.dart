import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/websocket_service.dart';
import '../services/notification_service.dart';
import '../models/patient_model.dart';
import '../models/hospital_model.dart';

class RealTimeProvider extends ChangeNotifier {
  final WebSocketService _webSocketService = WebSocketService();
  final NotificationService _notificationService = NotificationService();
  
  StreamSubscription? _webSocketSubscription;
  StreamSubscription? _connectionSubscription;
  
  // Connection state
  WebSocketConnectionStatus _connectionStatus = WebSocketConnectionStatus.disconnected;
  String? _lastErrorMessage;
  
  // Real-time data
  final Map<int, Patient> _livePatients = {};
  final Map<int, Hospital> _liveHospitals = {};
  final List<Map<String, dynamic>> _emergencyAlerts = [];
  final List<Map<String, dynamic>> _systemMessages = [];
  
  // Statistics
  int _activePatientsCount = 0;
  int _criticalPatientsCount = 0;
  int _availableBedsCount = 0;
  int _totalHospitalCapacity = 0;
  
  // Getters
  WebSocketConnectionStatus get connectionStatus => _connectionStatus;
  String? get lastErrorMessage => _lastErrorMessage;
  bool get isConnected => _connectionStatus == WebSocketConnectionStatus.connected;
  bool get isConnecting => _connectionStatus == WebSocketConnectionStatus.connecting;
  
  Map<int, Patient> get livePatients => Map.unmodifiable(_livePatients);
  Map<int, Hospital> get liveHospitals => Map.unmodifiable(_liveHospitals);
  List<Map<String, dynamic>> get emergencyAlerts => List.unmodifiable(_emergencyAlerts);
  List<Map<String, dynamic>> get systemMessages => List.unmodifiable(_systemMessages);
  
  int get activePatientsCount => _activePatientsCount;
  int get criticalPatientsCount => _criticalPatientsCount;
  int get availableBedsCount => _availableBedsCount;
  int get totalHospitalCapacity => _totalHospitalCapacity;
  
  double get hospitalOccupancyRate => 
      _totalHospitalCapacity > 0 
          ? ((_totalHospitalCapacity - _availableBedsCount) / _totalHospitalCapacity) * 100 
          : 0.0;

  /// Initialize real-time connection
  Future<void> initialize(String token) async {
    try {
      // Initialize notification service
      await _notificationService.initialize();
      
      // Listen to connection status changes
      _connectionSubscription = _webSocketService.connectionStatus.listen(_onConnectionStatusChanged);
      
      // Listen to WebSocket messages
      _webSocketSubscription = _webSocketService.messages.listen(_handleWebSocketMessage);
      
      // Connect to WebSocket
      await _webSocketService.connect(token);
      
    } catch (e) {
      _lastErrorMessage = 'Failed to initialize real-time connection: $e';
      notifyListeners();
    }
  }

  /// Handle connection status changes
  void _onConnectionStatusChanged(WebSocketConnectionStatus status) {
    _connectionStatus = status;
    
    if (status == WebSocketConnectionStatus.connected) {
      _lastErrorMessage = null;
      _subscribeToChannels();
    } else if (status == WebSocketConnectionStatus.error) {
      _lastErrorMessage = 'Connection error occurred';
    }
    
    notifyListeners();
  }

  /// Subscribe to all necessary channels
  void _subscribeToChannels() {
    // Subscribe to emergency alerts
    _webSocketService.subscribeToEmergencyAlerts();
    
    // Subscribe to general patient and hospital updates
    // Individual subscriptions will be handled when viewing specific screens
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'patient_update':
        _handlePatientUpdate(message);
        break;
      case 'hospital_update':
        _handleHospitalUpdate(message);
        break;
      case 'emergency_alert':
        _handleEmergencyAlert(message);
        break;
      case 'system_message':
        _handleSystemMessage(message);
        break;
      case 'stats_update':
        _handleStatsUpdate(message);
        break;
      case 'batch_update':
        _handleBatchUpdate(message);
        break;
    }
  }

  /// Handle patient updates
  void _handlePatientUpdate(Map<String, dynamic> message) {
    try {
      final patientData = message['data'];
      final patient = Patient.fromJson(patientData);
      
      _livePatients[patient.id] = patient;
      
      // Update statistics
      _updatePatientStatistics();
      
      notifyListeners();
    } catch (e) {
      print('Error handling patient update: $e');
    }
  }

  /// Handle hospital updates
  void _handleHospitalUpdate(Map<String, dynamic> message) {
    try {
      final hospitalData = message['data'];
      final hospital = Hospital.fromJson(hospitalData);
      
      _liveHospitals[hospital.id] = hospital;
      
      // Update statistics
      _updateHospitalStatistics();
      
      notifyListeners();
    } catch (e) {
      print('Error handling hospital update: $e');
    }
  }

  /// Handle emergency alerts
  void _handleEmergencyAlert(Map<String, dynamic> message) {
    _emergencyAlerts.insert(0, {
      ...message,
      'timestamp': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    
    // Keep only last 50 alerts
    if (_emergencyAlerts.length > 50) {
      _emergencyAlerts.removeRange(50, _emergencyAlerts.length);
    }
    
    notifyListeners();
  }

  /// Handle system messages
  void _handleSystemMessage(Map<String, dynamic> message) {
    _systemMessages.insert(0, {
      ...message,
      'timestamp': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    
    // Keep only last 100 messages
    if (_systemMessages.length > 100) {
      _systemMessages.removeRange(100, _systemMessages.length);
    }
    
    notifyListeners();
  }

  /// Handle statistics updates
  void _handleStatsUpdate(Map<String, dynamic> message) {
    final stats = message['data'];
    
    _activePatientsCount = stats['active_patients'] ?? _activePatientsCount;
    _criticalPatientsCount = stats['critical_patients'] ?? _criticalPatientsCount;
    _availableBedsCount = stats['available_beds'] ?? _availableBedsCount;
    _totalHospitalCapacity = stats['total_capacity'] ?? _totalHospitalCapacity;
    
    notifyListeners();
  }

  /// Handle batch updates (multiple entities at once)
  void _handleBatchUpdate(Map<String, dynamic> message) {
    final updates = message['data'] as List<dynamic>? ?? [];
    
    for (final update in updates) {
      switch (update['type']) {
        case 'patient':
          _handlePatientUpdate({'data': update['data']});
          break;
        case 'hospital':
          _handleHospitalUpdate({'data': update['data']});
          break;
      }
    }
  }

  /// Subscribe to specific patient updates
  void subscribeToPatient(int patientId) {
    _webSocketService.subscribeToPatient(patientId);
  }

  /// Unsubscribe from specific patient updates
  void unsubscribeFromPatient(int patientId) {
    _webSocketService.unsubscribeFromPatient(patientId);
  }

  /// Subscribe to specific hospital updates
  void subscribeToHospital(int hospitalId) {
    _webSocketService.subscribeToHospital(hospitalId);
  }

  /// Send patient status update
  void updatePatientStatus(int patientId, String status) {
    _webSocketService.sendPatientStatusUpdate(patientId, status);
  }

  /// Send emergency alert
  void sendEmergencyAlert({
    required String message,
    required String severity,
    int? patientId,
    int? hospitalId,
    Map<String, dynamic>? additionalData,
  }) {
    _webSocketService.sendEmergencyAlert({
      'message': message,
      'severity': severity,
      'patient_id': patientId,
      'hospital_id': hospitalId,
      ...?additionalData,
    });
  }

  /// Send hospital capacity update
  void updateHospitalCapacity(int hospitalId, int availableBeds) {
    _webSocketService.sendHospitalCapacityUpdate(hospitalId, availableBeds);
  }

  /// Update patient statistics
  void _updatePatientStatistics() {
    _activePatientsCount = _livePatients.values
        .where((p) => p.status != 'discharged' && p.status != 'transferred')
        .length;
    
    _criticalPatientsCount = _livePatients.values
        .where((p) => p.status == 'critical')
        .length;
  }

  /// Update hospital statistics
  void _updateHospitalStatistics() {
    _availableBedsCount = _liveHospitals.values
        .fold(0, (sum, hospital) => sum + hospital.availableBeds);
    
    _totalHospitalCapacity = _liveHospitals.values
        .fold(0, (sum, hospital) => sum + hospital.capacity);
  }

  /// Get patient by ID with real-time data
  Patient? getPatientById(int patientId) {
    return _livePatients[patientId];
  }

  /// Get hospital by ID with real-time data
  Hospital? getHospitalById(int hospitalId) {
    return _liveHospitals[hospitalId];
  }

  /// Get patients by status with real-time data
  List<Patient> getPatientsByStatus(String status) {
    return _livePatients.values
        .where((patient) => patient.status == status)
        .toList();
  }

  /// Get hospitals with available beds
  List<Hospital> getHospitalsWithAvailableBeds() {
    return _liveHospitals.values
        .where((hospital) => hospital.availableBeds > 0)
        .toList();
  }

  /// Get recent emergency alerts
  List<Map<String, dynamic>> getRecentEmergencyAlerts([int limit = 10]) {
    return _emergencyAlerts.take(limit).toList();
  }

  /// Get recent system messages
  List<Map<String, dynamic>> getRecentSystemMessages([int limit = 20]) {
    return _systemMessages.take(limit).toList();
  }

  /// Clear emergency alerts
  void clearEmergencyAlerts() {
    _emergencyAlerts.clear();
    notifyListeners();
  }

  /// Clear system messages
  void clearSystemMessages() {
    _systemMessages.clear();
    notifyListeners();
  }

  /// Reconnect to WebSocket
  Future<void> reconnect(String token) async {
    await _webSocketService.connect(token);
  }

  /// Disconnect from WebSocket
  void disconnect() {
    _webSocketService.disconnect();
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _connectionSubscription?.cancel();
    _webSocketService.disconnect();
    super.dispose();
  }
}