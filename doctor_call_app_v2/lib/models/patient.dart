class Patient {
  final int id;
  final int hospitalId;
  final int severity;
  final String conditionCode;
  final int triagePriority;
  final PatientStatus status;
  final DateTime? eta;
  final DateTime? waitSince;
  final DateTime createdAt;
  final DateTime updatedAt;

  Patient({
    required this.id,
    required this.hospitalId,
    required this.severity,
    required this.conditionCode,
    required this.triagePriority,
    required this.status,
    this.eta,
    this.waitSince,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      hospitalId: json['hospital_id'],
      severity: json['severity'],
      conditionCode: json['condition_code'],
      triagePriority: json['triage_priority'],
      status: PatientStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      eta: json['eta'] != null ? DateTime.parse(json['eta']) : null,
      waitSince: json['wait_since'] != null
          ? DateTime.parse(json['wait_since'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'severity': severity,
      'condition_code': conditionCode,
      'triage_priority': triagePriority,
      'status': status.toString().split('.').last,
      'eta': eta?.toIso8601String(),
      'wait_since': waitSince?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // حساب وقت الانتظار بالدقائق
  int get waitingTimeMinutes {
    if (waitSince == null) return 0;
    return DateTime.now().difference(waitSince!).inMinutes;
  }

  // النص التوضيحي للحالة
  String get conditionDescription {
    switch (conditionCode) {
      case 'HEART_ATTACK':
        return 'أزمة قلبية';
      case 'STROKE':
        return 'جلطة دماغية';
      case 'SEVERE_TRAUMA':
        return 'إصابة شديدة';
      case 'CHEST_PAIN':
        return 'ألم في الصدر';
      case 'FRACTURE':
        return 'كسر';
      case 'HIGH_FEVER':
        return 'حمى عالية';
      case 'MINOR_CUT':
        return 'جرح بسيط';
      case 'COLD_SYMPTOMS':
        return 'أعراض برد';
      case 'ROUTINE_CHECKUP':
        return 'فحص دوري';
      default:
        return conditionCode;
    }
  }

  // لون الأولوية
  String get priorityColor {
    switch (triagePriority) {
      case 1:
        return '#D32F2F'; // أحمر - طوارئ
      case 2:
        return '#F57C00'; // برتقالي - عاجل
      case 3:
        return '#FBC02D'; // أصفر - متوسط
      case 4:
        return '#388E3C'; // أخضر - عادي
      case 5:
        return '#1976D2'; // أزرق - غير عاجل
      default:
        return '#757575'; // رمادي
    }
  }

  // نص الأولوية
  String get priorityText {
    switch (triagePriority) {
      case 1:
        return 'طوارئ فورية';
      case 2:
        return 'عاجل';
      case 3:
        return 'متوسط الأولوية';
      case 4:
        return 'عادي';
      case 5:
        return 'غير عاجل';
      default:
        return 'غير محدد';
    }
  }
}

enum PatientStatus { wait, inService, obs, done, dead }

extension PatientStatusExtension on PatientStatus {
  String get displayName {
    switch (this) {
      case PatientStatus.wait:
        return 'في الانتظار';
      case PatientStatus.inService:
        return 'قيد الخدمة';
      case PatientStatus.obs:
        return 'تحت المراقبة';
      case PatientStatus.done:
        return 'مكتمل';
      case PatientStatus.dead:
        return 'متوفى';
    }
  }

  String get color {
    switch (this) {
      case PatientStatus.wait:
        return '#FF9800'; // برتقالي
      case PatientStatus.inService:
        return '#2196F3'; // أزرق
      case PatientStatus.obs:
        return '#FF5722'; // أحمر برتقالي
      case PatientStatus.done:
        return '#4CAF50'; // أخضر
      case PatientStatus.dead:
        return '#424242'; // رمادي غامق
    }
  }
}
