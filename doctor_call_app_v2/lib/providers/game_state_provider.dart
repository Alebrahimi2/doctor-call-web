import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/hospital.dart';
import '../models/patient.dart';
import '../models/game_avatar.dart';
import '../services/dio_api_service.dart';

class GameStateProvider extends ChangeNotifier {
  // Current User
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Authentication State
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Game Data
  List<Hospital> _hospitals = [];
  List<Hospital> get hospitals => _hospitals;

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  List<GameAvatar> _staffAvatars = [];
  List<GameAvatar> get staffAvatars => _staffAvatars;

  List<GameAvatar> _patientAvatars = [];
  List<GameAvatar> get patientAvatars => _patientAvatars;

  Hospital? _selectedHospital;
  Hospital? get selectedHospital => _selectedHospital;

  // Game Statistics
  Map<String, dynamic> _gameStats = {};
  Map<String, dynamic> get gameStats => _gameStats;

  Map<String, dynamic> _hospitalStats = {};
  Map<String, dynamic> get hospitalStats => _hospitalStats;

  // ============ Authentication Methods ============

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await dioApiService.login(email, password);

      if (response.success) {
        _isAuthenticated = true;
        await _loadCurrentUser();
        await _loadInitialData();
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'فشل في تسجيل الدخول');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('خطأ في الاتصال');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await dioApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      if (response.success) {
        _isAuthenticated = true;
        await _loadCurrentUser();
        await _loadInitialData();
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'فشل في التسجيل');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('خطأ في الاتصال');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await dioApiService.logout();
    } catch (e) {
      // تسجيل الخروج محلياً حتى لو فشل الطلب
    }

    _clearAllData();
    _isAuthenticated = false;
    _setLoading(false);
    notifyListeners();
  }

  // ============ User Methods ============

  Future<void> _loadCurrentUser() async {
    try {
      final response = await dioApiService.getCurrentUser();
      if (response.success) {
        _currentUser = response.data;
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await dioApiService.updateUser(userData);

      if (response.success) {
        _currentUser = response.data;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'فشل في تحديث البيانات');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('خطأ في الاتصال');
      _setLoading(false);
      return false;
    }
  }

  // ============ Hospital Methods ============

  Future<void> loadHospitals() async {
    try {
      final response = await dioApiService.getHospitals();
      if (response.success) {
        _hospitals = response.data ?? [];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading hospitals: $e');
    }
  }

  Future<bool> createHospital(Map<String, dynamic> hospitalData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await dioApiService.createHospital(hospitalData);

      if (response.success) {
        _hospitals.add(response.data!);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'فشل في إنشاء المستشفى');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('خطأ في الاتصال');
      _setLoading(false);
      return false;
    }
  }

  void selectHospital(Hospital hospital) {
    _selectedHospital = hospital;
    loadHospitalData(hospital.id);
    notifyListeners();
  }

  Future<void> loadHospitalData(int hospitalId) async {
    await Future.wait([
      loadPatients(hospitalId: hospitalId),
      loadAvatars(hospitalId: hospitalId),
      loadHospitalStats(hospitalId),
    ]);
  }

  // ============ Patient Methods ============

  Future<void> loadPatients({int? hospitalId}) async {
    try {
      final response = await dioApiService.getPatients(hospitalId: hospitalId);
      if (response.success) {
        _patients = response.data ?? [];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading patients: $e');
    }
  }

  Future<bool> updatePatientStatus(int patientId, PatientStatus status) async {
    try {
      final response = await dioApiService.updatePatientStatus(
        patientId,
        status,
      );

      if (response.success) {
        // تحديث المريض في القائمة المحلية
        final index = _patients.indexWhere((p) => p.id == patientId);
        if (index != -1) {
          _patients[index] = response.data!;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating patient status: $e');
      return false;
    }
  }

  List<Patient> getPatientsByStatus(PatientStatus status) {
    return _patients.where((p) => p.status == status).toList();
  }

  List<Patient> getPatientsByPriority(int priority) {
    return _patients.where((p) => p.triagePriority == priority).toList();
  }

  // ============ Avatar Methods ============

  Future<void> loadAvatars({int? hospitalId}) async {
    try {
      // Load staff avatars
      final staffResponse = await dioApiService.getAvatars(
        type: AvatarType.staff,
        hospitalId: hospitalId,
      );
      if (staffResponse.success) {
        _staffAvatars = staffResponse.data ?? [];
      }

      // Load patient avatars
      final patientResponse = await dioApiService.getAvatars(
        type: AvatarType.patient,
        hospitalId: hospitalId,
      );
      if (patientResponse.success) {
        _patientAvatars = patientResponse.data ?? [];
      }

      notifyListeners();
    } catch (e) {
      print('Error loading avatars: $e');
    }
  }

  Future<bool> updateAvatarStatus(
    int avatarId,
    Map<String, dynamic> status,
  ) async {
    try {
      final response = await dioApiService.updateAvatarStatus(avatarId, status);

      if (response.success) {
        // تحديث الشخصية في القائمة المحلية
        _updateAvatarInList(response.data!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating avatar status: $e');
      return false;
    }
  }

  void _updateAvatarInList(GameAvatar updatedAvatar) {
    if (updatedAvatar.type == AvatarType.staff) {
      final index = _staffAvatars.indexWhere((a) => a.id == updatedAvatar.id);
      if (index != -1) {
        _staffAvatars[index] = updatedAvatar;
      }
    } else {
      final index = _patientAvatars.indexWhere((a) => a.id == updatedAvatar.id);
      if (index != -1) {
        _patientAvatars[index] = updatedAvatar;
      }
    }
  }

  List<GameAvatar> getAvailableStaff() {
    return _staffAvatars
        .where(
          (avatar) =>
              avatar.status == AvatarStatus.available && avatar.energy > 20,
        )
        .toList();
  }

  List<GameAvatar> getStaffBySpecialty(String specialty) {
    return _staffAvatars
        .where((avatar) => avatar.specialty == specialty)
        .toList();
  }

  // ============ Statistics Methods ============

  Future<void> loadGameStats() async {
    try {
      final response = await dioApiService.getGameStats();
      if (response.success) {
        _gameStats = response.data ?? {};
        notifyListeners();
      }
    } catch (e) {
      print('Error loading game stats: $e');
    }
  }

  Future<void> loadHospitalStats(int hospitalId) async {
    try {
      final response = await dioApiService.getHospitalStats(hospitalId);
      if (response.success) {
        _hospitalStats = response.data ?? {};
        notifyListeners();
      }
    } catch (e) {
      print('Error loading hospital stats: $e');
    }
  }

  // ============ Real-time Updates ============

  Future<void> refreshRealtimeData() async {
    if (_selectedHospital != null) {
      await Future.wait([
        loadPatients(hospitalId: _selectedHospital!.id),
        loadAvatars(hospitalId: _selectedHospital!.id),
      ]);
    }
  }

  // ============ Utility Methods ============

  Future<void> _loadInitialData() async {
    await Future.wait([loadHospitals(), loadGameStats()]);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String error) {
    _error = error;
  }

  void _clearError() {
    _error = null;
  }

  void _clearAllData() {
    _currentUser = null;
    _hospitals.clear();
    _patients.clear();
    _staffAvatars.clear();
    _patientAvatars.clear();
    _selectedHospital = null;
    _gameStats.clear();
    _hospitalStats.clear();
    _clearError();
  }

  // ============ Computed Properties ============

  // إحصائيات سريعة للوحة التحكم
  Map<String, int> get quickStats {
    return {
      'totalHospitals': _hospitals.length,
      'totalPatients': _patients.length,
      'waitingPatients': _patients
          .where((p) => p.status == PatientStatus.wait)
          .length,
      'inServicePatients': _patients
          .where((p) => p.status == PatientStatus.inService)
          .length,
      'totalStaff': _staffAvatars.length,
      'availableStaff': _staffAvatars
          .where((a) => a.status == AvatarStatus.available)
          .length,
    };
  }

  // مستوى الطوارئ في المستشفى المحددة
  String get emergencyLevel {
    if (_selectedHospital == null) return 'غير محدد';

    final urgentPatients = _patients
        .where((p) => p.triagePriority <= 2 && p.status == PatientStatus.wait)
        .length;

    if (urgentPatients >= 10) return 'طوارئ حرجة';
    if (urgentPatients >= 5) return 'طوارئ متوسطة';
    if (urgentPatients >= 1) return 'طوارئ خفيفة';
    return 'مستقر';
  }
}
