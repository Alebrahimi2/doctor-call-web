class Hospital {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final HospitalStatus status;
  final double latitude;
  final double longitude;
  final int capacity;
  final int currentLoad;
  final double efficiency;
  final int level;
  final double reputation;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.currentLoad,
    required this.efficiency,
    required this.level,
    required this.reputation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      status: HospitalStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      capacity: json['capacity'],
      currentLoad: json['current_load'],
      efficiency: json['efficiency'].toDouble(),
      level: json['level'],
      reputation: json['reputation'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'status': status.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': capacity,
      'current_load': currentLoad,
      'efficiency': efficiency,
      'level': level,
      'reputation': reputation,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // حساب النسبة المئوية للاستخدام
  double get utilizationRate {
    if (capacity == 0) return 0.0;
    return (currentLoad / capacity) * 100;
  }

  // حالة التشغيل
  String get operationalStatus {
    double utilization = utilizationRate;
    if (utilization >= 95) return 'مكتظ';
    if (utilization >= 80) return 'مشغول';
    if (utilization >= 50) return 'متوسط';
    if (utilization >= 25) return 'هادئ';
    return 'فارغ';
  }

  // لون حالة التشغيل
  String get operationalColor {
    double utilization = utilizationRate;
    if (utilization >= 95) return '#D32F2F'; // أحمر
    if (utilization >= 80) return '#FF5722'; // برتقالي أحمر
    if (utilization >= 50) return '#FF9800'; // برتقالي
    if (utilization >= 25) return '#4CAF50'; // أخضر
    return '#2196F3'; // أزرق
  }

  // مستوى السمعة
  String get reputationLevel {
    if (reputation >= 90) return 'ممتاز';
    if (reputation >= 80) return 'جيد جداً';
    if (reputation >= 70) return 'جيد';
    if (reputation >= 60) return 'مقبول';
    return 'ضعيف';
  }

  // أيقونة المستوى
  String get levelIcon {
    if (level >= 10) return '🏆';
    if (level >= 8) return '⭐';
    if (level >= 6) return '🥇';
    if (level >= 4) return '🥈';
    if (level >= 2) return '🥉';
    return '🏥';
  }

  // النقاط المطلوبة للمستوى التالي
  int get pointsToNextLevel {
    return (level + 1) * 1000;
  }

  // هل المستشفى متاح للاستقبال؟
  bool get isAvailable {
    return status == HospitalStatus.active && utilizationRate < 100;
  }

  // نسبة الكفاءة مع النص
  String get efficiencyText {
    if (efficiency >= 95) return 'كفاءة عالية جداً';
    if (efficiency >= 85) return 'كفاءة عالية';
    if (efficiency >= 75) return 'كفاءة جيدة';
    if (efficiency >= 65) return 'كفاءة متوسطة';
    return 'كفاءة منخفضة';
  }
}

enum HospitalStatus { active, maintenance, emergency, closed }

extension HospitalStatusExtension on HospitalStatus {
  String get displayName {
    switch (this) {
      case HospitalStatus.active:
        return 'نشط';
      case HospitalStatus.maintenance:
        return 'صيانة';
      case HospitalStatus.emergency:
        return 'طوارئ';
      case HospitalStatus.closed:
        return 'مغلق';
    }
  }

  String get color {
    switch (this) {
      case HospitalStatus.active:
        return '#4CAF50'; // أخضر
      case HospitalStatus.maintenance:
        return '#FF9800'; // برتقالي
      case HospitalStatus.emergency:
        return '#F44336'; // أحمر
      case HospitalStatus.closed:
        return '#9E9E9E'; // رمادي
    }
  }

  String get icon {
    switch (this) {
      case HospitalStatus.active:
        return '✅';
      case HospitalStatus.maintenance:
        return '🔧';
      case HospitalStatus.emergency:
        return '🚨';
      case HospitalStatus.closed:
        return '🔒';
    }
  }
}
