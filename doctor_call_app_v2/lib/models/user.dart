class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final UserRole role;
  final UserStatus status;
  final int? hospitalId;
  final String? phone;
  final String? address;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Game-specific fields
  final int experience;
  final int level;
  final int coins;
  final int gems;
  final double playTime;
  final DateTime? lastActiveAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    required this.status,
    this.hospitalId,
    this.phone,
    this.address,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.experience = 0,
    this.level = 1,
    this.coins = 1000,
    this.gems = 10,
    this.playTime = 0.0,
    this.lastActiveAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      hospitalId: json['hospital_id'],
      phone: json['phone'],
      address: json['address'],
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      experience: json['experience'] ?? 0,
      level: json['level'] ?? 1,
      coins: json['coins'] ?? 1000,
      gems: json['gems'] ?? 10,
      playTime: (json['play_time'] ?? 0.0).toDouble(),
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'role': role.toString().split('.').last,
      'status': status.toString().split('.').last,
      'hospital_id': hospitalId,
      'phone': phone,
      'address': address,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'experience': experience,
      'level': level,
      'coins': coins,
      'gems': gems,
      'play_time': playTime,
      'last_active_at': lastActiveAt?.toIso8601String(),
    };
  }

  // النقاط المطلوبة للمستوى التالي
  int get experienceToNextLevel {
    return (level * 100) + ((level - 1) * 50);
  }

  // النقاط الحالية للمستوى
  int get currentLevelExperience {
    int totalForPreviousLevels = 0;
    for (int i = 1; i < level; i++) {
      totalForPreviousLevels += (i * 100) + ((i - 1) * 50);
    }
    return experience - totalForPreviousLevels;
  }

  // نسبة التقدم للمستوى التالي
  double get progressToNextLevel {
    int current = currentLevelExperience;
    int needed = experienceToNextLevel;
    if (needed == 0) return 1.0;
    return (current / needed).clamp(0.0, 1.0);
  }

  // رتبة اللاعب
  String get playerRank {
    if (level >= 50) return 'أسطورة طبية';
    if (level >= 40) return 'خبير متقدم';
    if (level >= 30) return 'طبيب خبير';
    if (level >= 20) return 'طبيب متمرس';
    if (level >= 15) return 'طبيب ماهر';
    if (level >= 10) return 'طبيب مبتدئ';
    if (level >= 5) return 'متدرب متقدم';
    return 'متدرب مبتدئ';
  }

  // لون الرتبة
  String get rankColor {
    if (level >= 50) return '#FFD700'; // ذهبي
    if (level >= 40) return '#C0C0C0'; // فضي
    if (level >= 30) return '#CD7F32'; // برونزي
    if (level >= 20) return '#9C27B0'; // بنفسجي
    if (level >= 15) return '#3F51B5'; // أزرق غامق
    if (level >= 10) return '#2196F3'; // أزرق
    if (level >= 5) return '#4CAF50'; // أخضر
    return '#FF9800'; // برتقالي
  }

  // أيقونة الرتبة
  String get rankIcon {
    if (level >= 50) return '👑';
    if (level >= 40) return '⭐';
    if (level >= 30) return '🏆';
    if (level >= 20) return '🥇';
    if (level >= 15) return '🥈';
    if (level >= 10) return '🥉';
    if (level >= 5) return '🎖️';
    return '🔰';
  }

  // هل اللاعب نشط؟
  bool get isActive {
    if (lastActiveAt == null) return false;
    return DateTime.now().difference(lastActiveAt!).inHours < 24;
  }

  // وقت اللعب بالساعات
  String get playTimeFormatted {
    int hours = playTime.toInt();
    int minutes = ((playTime % 1) * 60).toInt();
    if (hours > 0) {
      return '${hours}س ${minutes}د';
    }
    return '${minutes}د';
  }

  // تحديث نشاط اللاعب
  User copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    UserRole? role,
    UserStatus? status,
    int? hospitalId,
    int? experience,
    int? level,
    int? coins,
    int? gems,
    double? playTime,
    DateTime? lastActiveAt,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt,
      role: role ?? this.role,
      status: status ?? this.status,
      hospitalId: hospitalId ?? this.hospitalId,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      experience: experience ?? this.experience,
      level: level ?? this.level,
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      playTime: playTime ?? this.playTime,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}

enum UserRole { admin, manager, doctor, nurse, player }

enum UserStatus { active, inactive, suspended, pending }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'مدير النظام';
      case UserRole.manager:
        return 'مدير المستشفى';
      case UserRole.doctor:
        return 'طبيب';
      case UserRole.nurse:
        return 'ممرض/ة';
      case UserRole.player:
        return 'لاعب';
    }
  }

  String get color {
    switch (this) {
      case UserRole.admin:
        return '#F44336'; // أحمر
      case UserRole.manager:
        return '#9C27B0'; // بنفسجي
      case UserRole.doctor:
        return '#2196F3'; // أزرق
      case UserRole.nurse:
        return '#4CAF50'; // أخضر
      case UserRole.player:
        return '#FF9800'; // برتقالي
    }
  }
}

extension UserStatusExtension on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'نشط';
      case UserStatus.inactive:
        return 'غير نشط';
      case UserStatus.suspended:
        return 'موقوف';
      case UserStatus.pending:
        return 'في الانتظار';
    }
  }

  String get color {
    switch (this) {
      case UserStatus.active:
        return '#4CAF50'; // أخضر
      case UserStatus.inactive:
        return '#9E9E9E'; // رمادي
      case UserStatus.suspended:
        return '#F44336'; // أحمر
      case UserStatus.pending:
        return '#FF9800'; // برتقالي
    }
  }
}
