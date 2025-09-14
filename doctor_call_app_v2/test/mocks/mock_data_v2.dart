import 'package:doctor_call_app_v2/core/models/user_model.dart';
import 'package:doctor_call_app_v2/core/models/patient_model.dart';
import 'package:doctor_call_app_v2/core/models/hospital_model.dart';
import 'package:doctor_call_app_v2/core/models/game_models.dart';

class MockData {
  // Mock User Data
  static UserModel get mockUser => UserModel(
    id: 1,
    name: 'د. أحمد محمد',
    email: 'ahmed@hospital.com',
    phone: '+966501234567',
    role: 'doctor',
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  // Mock Patients Data
  static List<Patient> get mockPatients => [
    Patient(
      id: 1,
      name: 'أحمد محمد',
      nationalId: '1234567890',
      phoneNumber: '+966501111111',
      age: 35,
      gender: 'male',
      status: 'waiting',
      medicalHistory: 'مريض بالسكري',
      priority: 'normal',
      admissionDate: DateTime.now().subtract(Duration(hours: 2)),
      hospitalId: 1,
      assignedDoctor: 'د. أحمد محمد',
    ),
    Patient(
      id: 2,
      name: 'فاطمة علي',
      nationalId: '2345678901',
      phoneNumber: '+966502222222',
      age: 28,
      gender: 'female',
      status: 'in_progress',
      medicalHistory: 'لا يوجد',
      priority: 'urgent',
      admissionDate: DateTime.now().subtract(Duration(hours: 1)),
      hospitalId: 1,
      assignedDoctor: 'د. فاطمة علي',
    ),
    Patient(
      id: 3,
      name: 'محمد حسن',
      nationalId: '3456789012',
      phoneNumber: '+966503333333',
      age: 42,
      gender: 'male',
      status: 'completed',
      medicalHistory: 'ضغط الدم المرتفع',
      priority: 'normal',
      admissionDate: DateTime.now().subtract(Duration(hours: 4)),
      hospitalId: 2,
      assignedDoctor: 'د. محمد حسن',
    ),
  ];

  // Mock Hospitals Data
  static List<Hospital> get mockHospitals => [
    Hospital(
      id: 1,
      name: 'مستشفى الملك فهد',
      location: 'الرياض، حي الملك فهد',
      phoneNumber: '+966112345678',
      email: 'info@kingfahd.hospital.sa',
      capacity: 500,
      availableBeds: 75,
      specialization: 'مستشفى عام',
      description: 'مستشفى متخصص في جميع التخصصات الطبية',
      status: 'active',
      latitude: 24.7136,
      longitude: 46.6753,
      createdAt: DateTime.now().subtract(Duration(days: 365)),
      updatedAt: DateTime.now(),
    ),
    Hospital(
      id: 2,
      name: 'مستشفى الملك خالد',
      location: 'جدة، حي الحمراء',
      phoneNumber: '+966122345678',
      email: 'info@kingkhalid.hospital.sa',
      capacity: 400,
      availableBeds: 120,
      specialization: 'طب الطوارئ',
      description: 'مستشفى متخصص في طب الطوارئ والحالات الحرجة',
      status: 'active',
      latitude: 21.5433,
      longitude: 39.1728,
      createdAt: DateTime.now().subtract(Duration(days: 300)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Mock Game Scores Data
  static List<GameScore> get mockGameScores => [
    GameScore(
      id: 1,
      userId: 1,
      patientId: 1,
      score: 85,
      responseTime: 45,
      isCorrect: true,
      difficulty: 'medium',
      achievedAt: DateTime.now().subtract(Duration(hours: 2)),
    ),
    GameScore(
      id: 2,
      userId: 1,
      patientId: 2,
      score: 70,
      responseTime: 60,
      isCorrect: true,
      difficulty: 'easy',
      achievedAt: DateTime.now().subtract(Duration(hours: 1)),
    ),
    GameScore(
      id: 3,
      userId: 1,
      patientId: 3,
      score: 95,
      responseTime: 30,
      isCorrect: true,
      difficulty: 'hard',
      achievedAt: DateTime.now().subtract(Duration(minutes: 30)),
    ),
  ];

  // Mock Achievements Data
  static List<Achievement> get mockAchievements => [
    Achievement(
      id: 1,
      name: 'التشخيص السريع',
      description: 'قم بتشخيص 10 حالات في أقل من دقيقة',
      iconUrl: 'assets/icons/fast_diagnosis.png',
      requiredPoints: 100,
      category: 'speed',
      requirements: {'diagnoses_count': 10, 'max_time': 60},
      unlockedAt: DateTime.now().subtract(Duration(days: 2)),
      isUnlocked: true,
      rarity: 'common',
      rewards: ['نقاط: +50', 'شارة التشخيص السريع'],
    ),
    Achievement(
      id: 2,
      name: 'الطبيب المحترف',
      description: 'احصل على دقة 95% في 50 تشخيص',
      iconUrl: 'assets/icons/professional_doctor.png',
      requiredPoints: 500,
      category: 'accuracy',
      requirements: {'accuracy_rate': 0.95, 'diagnoses_count': 50},
      unlockedAt: null,
      isUnlocked: false,
      rarity: 'epic',
      rewards: ['نقاط: +200', 'لقب: الطبيب المحترف'],
    ),
    Achievement(
      id: 3,
      name: 'المعالج الماهر',
      description: 'عالج 100 مريض بنجاح',
      iconUrl: 'assets/icons/skilled_healer.png',
      requiredPoints: 300,
      category: 'experience',
      requirements: {'treated_patients': 100},
      unlockedAt: DateTime.now().subtract(Duration(days: 5)),
      isUnlocked: true,
      rarity: 'rare',
      rewards: ['نقاط: +150', 'شارة المعالج الماهر'],
    ),
  ];

  // Mock Leaderboard Data
  static List<LeaderboardEntry> get mockLeaderboard => [
    LeaderboardEntry(
      userId: 1,
      userName: 'د. أحمد محمد',
      totalScore: 1250,
      rank: 1,
      hospitalName: 'مستشفى الملك فهد',
      achievementsCount: 12,
      lastActive: DateTime.now().subtract(Duration(hours: 1)),
    ),
    LeaderboardEntry(
      userId: 2,
      userName: 'د. فاطمة علي',
      totalScore: 1180,
      rank: 2,
      hospitalName: 'مستشفى الملك خالد',
      achievementsCount: 10,
      lastActive: DateTime.now().subtract(Duration(hours: 3)),
    ),
    LeaderboardEntry(
      userId: 3,
      userName: 'د. محمد حسن',
      totalScore: 1050,
      rank: 3,
      hospitalName: 'مستشفى الملك فهد',
      achievementsCount: 8,
      lastActive: DateTime.now().subtract(Duration(hours: 2)),
    ),
  ];

  // Mock Game Actions Data
  static List<GameAction> get mockGameActions => [
    GameAction(
      id: 1,
      userId: 1,
      patientId: 1,
      actionType: 'diagnosis',
      actionValue: 'الحمى الفيروسية',
      responseTime: 45,
      isCorrect: true,
      pointsEarned: 85,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
    ),
    GameAction(
      id: 2,
      userId: 1,
      patientId: 2,
      actionType: 'treatment',
      actionValue: 'أدوية خافض للحرارة',
      responseTime: 30,
      isCorrect: true,
      pointsEarned: 70,
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
  ];

  // Mock API Responses
  static Map<String, dynamic> get mockLoginResponse => {
    'success': true,
    'message': 'تم تسجيل الدخول بنجاح',
    'data': {
      'user': mockUser.toJson(),
      'token': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...',
      'expires_at': DateTime.now().add(Duration(days: 30)).toIso8601String(),
    },
  };

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

  static Map<String, dynamic> get mockNotFoundError => {
    'success': false,
    'message': 'Resource not found',
    'error_code': 404,
  };

  static Map<String, dynamic> get mockServerError => {
    'success': false,
    'message': 'Internal server error',
    'error_code': 500,
  };

  // Mock Game Statistics
  static Map<String, dynamic> get mockGameStats => {
    'total_score': 1250,
    'total_patients': 45,
    'success_rate': 0.89,
    'streak_days': 7,
    'achievements_count': 12,
    'rank': 5,
    'average_response_time': 52.3,
    'best_score': 95,
    'total_time_played': 1250, // minutes
  };

  // Mock Patient Symptoms
  static List<String> get mockSymptoms => [
    'صداع',
    'حمى',
    'ألم في البطن',
    'ضيق في التنفس',
    'ألم في الصدر',
    'غثيان',
    'دوخة',
    'ألم في الظهر',
  ];

  // Mock Diagnoses
  static List<String> get mockDiagnoses => [
    'الحمى الفيروسية',
    'التهاب المعدة',
    'الصداع النصفي',
    'التهاب الحلق',
    'نزلة البرد',
    'التهاب المفاصل',
    'حساسية الطعام',
    'ارتفاع ضغط الدم',
  ];

  // Mock Treatments
  static List<String> get mockTreatments => [
    'أدوية خافض للحرارة',
    'مسكن للألم',
    'مضاد حيوي',
    'أدوية مضادة للالتهاب',
    'علاج طبيعي',
    'راحة في الفراش',
    'شرب السوائل',
    'تغيير النظام الغذائي',
  ];
}