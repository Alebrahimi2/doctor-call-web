import 'package:doctor_call_app_v2/core/models/user_model.dart';
import 'package:doctor_call_app_v2/core/models/patient_model.dart';
import 'package:doctor_call_app_v2/core/models/hospital_model.dart';
import 'package:doctor_call_app_v2/core/models/game_models.dart';

class MockData {
  // Mock User Data
  static UserModel get mockUser => UserModel(
    id: 1,
    name: 'د. أحمد محمد',
    email: 'ahmed@example.com',
    hospitalId: 1,
    role: 'doctor',
    avatar: 'https://example.com/avatar.jpg',
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  static User get mockAdmin => User(
    id: 2,
    name: 'المدير العام',
    email: 'admin@example.com',
    hospitalId: 1,
    role: 'admin',
    avatar: 'https://example.com/admin-avatar.jpg',
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
    updatedAt: DateTime.now(),
  );

  // Mock Hospital Data
  static Hospital get mockHospital => Hospital(
    id: 1,
    name: 'مستشفى الملك فهد',
    address: 'الرياض، المملكة العربية السعودية',
    phone: '+966112345678',
    email: 'info@kfh.med.sa',
    capacity: 500,
    currentPatients: 350,
    departments: ['طوارئ', 'قلب', 'جراحة', 'أطفال', 'نساء وولادة'],
    isActive: true,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
  );

  static List<Hospital> get mockHospitals => [
    mockHospital,
    Hospital(
      id: 2,
      name: 'مستشفى الملك خالد',
      address: 'جدة، المملكة العربية السعودية',
      phone: '+966126789012',
      email: 'info@kkh.med.sa',
      capacity: 400,
      currentPatients: 280,
      departments: ['طوارئ', 'عيون', 'أنف وأذن', 'عظام'],
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Mock Patient Data
  static Patient get mockPatient => Patient(
    id: 1,
    name: 'سارة أحمد',
    age: 28,
    gender: 'female',
    phone: '+966501234567',
    address: 'الرياض، حي النخيل',
    medicalHistory: ['ضغط الدم', 'السكري'],
    currentCondition: 'مستقر',
    admissionDate: DateTime.now().subtract(const Duration(days: 2)),
    hospitalId: 1,
    assignedDoctorId: 1,
    priority: 'medium',
    status: 'admitted',
    emergencyContact: '+966507654321',
    notes: 'مريضة تحتاج متابعة يومية',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  );

  static List<Patient> get mockPatients => [
    mockPatient,
    Patient(
      id: 2,
      name: 'محمد علي',
      age: 45,
      gender: 'male',
      phone: '+966502345678',
      address: 'جدة، حي الصفا',
      medicalHistory: ['قلب'],
      currentCondition: 'حرج',
      admissionDate: DateTime.now().subtract(const Duration(hours: 6)),
      hospitalId: 1,
      assignedDoctorId: 1,
      priority: 'high',
      status: 'emergency',
      emergencyContact: '+966508765432',
      notes: 'يحتاج عملية عاجلة',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now(),
    ),
    Patient(
      id: 3,
      name: 'فاطمة حسن',
      age: 35,
      gender: 'female',
      phone: '+966503456789',
      address: 'الدمام، حي الجوهرة',
      medicalHistory: [],
      currentCondition: 'جيد',
      admissionDate: DateTime.now().subtract(const Duration(days: 1)),
      hospitalId: 2,
      assignedDoctorId: 2,
      priority: 'low',
      status: 'stable',
      emergencyContact: '+966509876543',
      notes: 'فحص روتيني',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Mock Game Data
  static GameScore get mockGameScore => GameScore(
    userId: 1,
    totalPoints: 2450,
    level: 8,
    experience: 2450,
    rank: 15,
    categoryPoints: {
      'patient_care': 1200,
      'emergency_response': 800,
      'hospital_management': 450,
    },
    weeklyPoints: 350,
    monthlyPoints: 1200,
    lastUpdated: DateTime.now(),
  );

  static List<Achievement> get mockAchievements => [
    Achievement(
      id: 1,
      name: 'طبيب مبتدئ',
      description: 'عالج أول 10 مرضى',
      category: 'patient_care',
      rarity: 'common',
      points: 100,
      requiredPoints: 10,
      currentProgress: 15,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 20)),
      hasReward: true,
      rewardClaimed: true,
    ),
    Achievement(
      id: 2,
      name: 'بطل الطوارئ',
      description: 'تعامل مع 50 حالة طوارئ',
      category: 'emergency_response',
      rarity: 'rare',
      points: 500,
      requiredPoints: 50,
      currentProgress: 32,
      isUnlocked: false,
      unlockedAt: null,
      hasReward: true,
      rewardClaimed: false,
    ),
    Achievement(
      id: 3,
      name: 'أسطورة الطب',
      description: 'حقق 10000 نقطة',
      category: 'overall',
      rarity: 'legendary',
      points: 2000,
      requiredPoints: 10000,
      currentProgress: 2450,
      isUnlocked: false,
      unlockedAt: null,
      hasReward: true,
      rewardClaimed: false,
    ),
  ];

  static List<LeaderboardEntry> get mockLeaderboard => [
    LeaderboardEntry(
      userId: 5,
      userName: 'د. خالد الأحمد',
      hospitalName: 'مستشفى الملك فهد',
      totalPoints: 5200,
      level: 12,
      rank: 1,
      achievementsCount: 25,
      weeklyGrowth: 450,
    ),
    LeaderboardEntry(
      userId: 3,
      userName: 'د. نورا السالم',
      hospitalName: 'مستشفى الملك خالد',
      totalPoints: 4800,
      level: 11,
      rank: 2,
      achievementsCount: 23,
      weeklyGrowth: 380,
    ),
    LeaderboardEntry(
      userId: 1,
      userName: 'د. أحمد محمد',
      hospitalName: 'مستشفى الملك فهد',
      totalPoints: 2450,
      level: 8,
      rank: 15,
      achievementsCount: 12,
      weeklyGrowth: 350,
    ),
  ];

  static List<GameAction> get mockGameHistory => [
    GameAction(
      id: 1,
      userId: 1,
      actionType: GameActionType.patientTreated,
      actionData: {'patient_id': 1, 'condition': 'stable'},
      pointsEarned: 50,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    GameAction(
      id: 2,
      userId: 1,
      actionType: GameActionType.emergencyHandled,
      actionData: {'emergency_type': 'cardiac', 'response_time': 5},
      pointsEarned: 150,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    GameAction(
      id: 3,
      userId: 1,
      actionType: GameActionType.hospitalManaged,
      actionData: {'hospital_id': 1, 'improvement': 'efficiency'},
      pointsEarned: 100,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Mock Challenges
  static List<Map<String, dynamic>> get mockDailyChallenges => [
    {
      'id': 1,
      'title': 'المساعد السريع',
      'description': 'عالج 5 مرضى اليوم',
      'target': 5,
      'progress': 3,
      'points': 100,
      'completed': false,
      'time_remaining': '8 ساعات',
    },
    {
      'id': 2,
      'title': 'بطل الطوارئ',
      'description': 'تعامل مع حالة طوارئ واحدة',
      'target': 1,
      'progress': 1,
      'points': 150,
      'completed': true,
      'completed_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
    },
  ];

  static List<Map<String, dynamic>> get mockWeeklyChallenges => [
    {
      'id': 3,
      'title': 'طبيب الأسبوع',
      'description': 'عالج 30 مريض هذا الأسبوع',
      'target': 30,
      'progress': 18,
      'points': 500,
      'completed': false,
      'time_remaining': '3 أيام',
    },
  ];

  static List<Map<String, dynamic>> get mockSeasonalEvents => [
    {
      'id': 1,
      'title': 'يوم الصحة العالمي',
      'description': 'احتفل بيوم الصحة العالمي واحصل على مكافآت خاصة',
      'is_active': true,
      'start_date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'end_date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'rewards': {'points': 1000, 'special_badge': true},
    },
  ];

  // Mock API Responses
  static Map<String, dynamic> get mockLoginResponse => {
    'success': true,
    'message': 'تم تسجيل الدخول بنجاح',
    'data': {
      'user': mockUser.toJson(),
      'token': 'mock_token_123456789',
      'expires_in': 86400,
    },
  };

  static Map<String, dynamic> get mockDashboardStats => {
    'total_patients': 342,
    'active_cases': 89,
    'today_admissions': 23,
    'emergency_cases': 5,
    'recent_patients': mockPatients.take(3).map((p) => p.toJson()).toList(),
    'hospitals_summary': mockHospitals.map((h) => h.toJson()).toList(),
  };

  static Map<String, dynamic> get mockGameStatsResponse => {
    'user_score': mockGameScore.toJson(),
    'achievements': mockAchievements.map((a) => a.toJson()).toList(),
    'leaderboard': mockLeaderboard.map((l) => l.toJson()).toList(),
    'daily_challenges': mockDailyChallenges,
    'weekly_challenges': mockWeeklyChallenges,
    'seasonal_events': mockSeasonalEvents,
  };

  // Error responses
  static Map<String, dynamic> get mockUnauthorizedError => {
    'success': false,
    'message': 'Unauthorized',
    'error_code': 401,
  };

  static Map<String, dynamic> get mockValidationError => {
    'success': false,
    'message': 'Validation failed',
    'errors': {
      'email': ['The email field is required.'],
      'password': ['The password must be at least 8 characters.'],
    },
    'error_code': 422,
  };

  static Map<String, dynamic> get mockServerError => {
    'success': false,
    'message': 'Internal server error',
    'error_code': 500,
  };

  static Map<String, dynamic> get mockNetworkError => {
    'success': false,
    'message': 'Network connection error',
    'error_code': -1,
  };
}