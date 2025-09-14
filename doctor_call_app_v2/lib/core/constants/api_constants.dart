class ApiConstants {
  // Base URL for the Laravel backend API
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Authentication endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshEndpoint = '/auth/refresh';
  static const String profileEndpoint = '/auth/profile';
  
  // Hospital endpoints
  static const String hospitalsEndpoint = '/hospitals';
  static const String hospitalStatsEndpoint = '/hospitals/stats';
  static const String nearbyHospitalsEndpoint = '/hospitals/nearby';
  
  // Patient endpoints
  static const String patientsEndpoint = '/patients';
  static const String patientStatsEndpoint = '/patients/stats';
  static const String patientSearchEndpoint = '/patients/search';
  static const String patientStatusEndpoint = '/patients/status';
  
  // Avatar endpoints
  static const String avatarsEndpoint = '/avatars';
  static const String myAvatarsEndpoint = '/avatars/my';
  static const String purchaseAvatarEndpoint = '/avatars/purchase';
  
  // Mission endpoints
  static const String missionsEndpoint = '/missions';
  static const String myMissionsEndpoint = '/missions/my';
  static const String completeMissionEndpoint = '/missions/complete';
  
  // Queue endpoints
  static const String queueEndpoint = '/queue';
  static const String queueStatsEndpoint = '/queue/stats';
  
  // Emergency endpoints
  static const String emergencyEndpoint = '/emergency';
  static const String emergencyStatsEndpoint = '/emergency/stats';
  
  // Communication endpoints
  static const String messagesEndpoint = '/messages';
  static const String notificationsEndpoint = '/notifications';
  
  // Game endpoints
  static const String leaderboardEndpoint = '/leaderboard';
  static const String achievementsEndpoint = '/achievements';
  static const String rewardsEndpoint = '/rewards';
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }
  
  // Response status codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // WebSocket endpoints (for future use)
  static const String wsBaseUrl = 'ws://localhost:8000';
  static const String wsPatientUpdates = '/ws/patients';
  static const String wsEmergencyAlerts = '/ws/emergency';
  static const String wsHospitalStatus = '/ws/hospitals';
  
  // File upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // Cache duration
  static const Duration cacheShortDuration = Duration(minutes: 5);
  static const Duration cacheMediumDuration = Duration(minutes: 30);
  static const Duration cacheLongDuration = Duration(hours: 2);
}