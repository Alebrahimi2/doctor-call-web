class GameAvatar {
  final int id;
  final int userId;
  final String avatarName;
  final AvatarType type;
  final AvatarStatus status;
  final String? specialty;
  final int experienceLevel;
  final List<String> skills;
  final Map<String, dynamic> appearance;
  final bool isActive;
  final bool isNPC;
  final String? backgroundStory;
  final int reputation;
  final int energy;
  final int morale;
  final int health;
  final int currentLevel;
  final int xp;
  final int stressLevel;
  final DateTime? lastMissionAt;
  final int missionsCompleted;
  final int missionsFailed;
  final DateTime createdAt;
  final DateTime updatedAt;

  GameAvatar({
    required this.id,
    required this.userId,
    required this.avatarName,
    required this.type,
    required this.status,
    this.specialty,
    required this.experienceLevel,
    required this.skills,
    required this.appearance,
    required this.isActive,
    required this.isNPC,
    this.backgroundStory,
    required this.reputation,
    required this.energy,
    required this.morale,
    required this.health,
    required this.currentLevel,
    required this.xp,
    required this.stressLevel,
    this.lastMissionAt,
    required this.missionsCompleted,
    required this.missionsFailed,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameAvatar.fromJson(Map<String, dynamic> json) {
    return GameAvatar(
      id: json['id'],
      userId: json['user_id'],
      avatarName: json['avatar_name'],
      type: AvatarType.values.firstWhere(
        (e) => e.toString().split('.').last == json['avatar_type'],
      ),
      status: AvatarStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AvatarStatus.available,
      ),
      specialty: json['specialty'],
      experienceLevel: json['experience_level'] ?? 1,
      skills: List<String>.from(json['skills'] ?? []),
      appearance: Map<String, dynamic>.from(json['appearance'] ?? {}),
      isActive: json['is_active'] ?? true,
      isNPC: json['is_npc'] ?? false,
      backgroundStory: json['background_story'],
      reputation: json['reputation'] ?? 50,
      energy: json['energy'] ?? 100,
      morale: json['morale'] ?? 50,
      health: json['health'] ?? 100,
      currentLevel: json['current_level'] ?? 1,
      xp: json['xp'] ?? 0,
      stressLevel: json['stress_level'] ?? 0,
      lastMissionAt: json['last_mission_at'] != null
          ? DateTime.parse(json['last_mission_at'])
          : null,
      missionsCompleted: json['missions_completed'] ?? 0,
      missionsFailed: json['missions_failed'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'avatar_name': avatarName,
      'avatar_type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'specialty': specialty,
      'experience_level': experienceLevel,
      'skills': skills,
      'appearance': appearance,
      'is_active': isActive,
      'is_npc': isNPC,
      'background_story': backgroundStory,
      'reputation': reputation,
      'energy': energy,
      'morale': morale,
      'health': health,
      'current_level': currentLevel,
      'xp': xp,
      'stress_level': stressLevel,
      'last_mission_at': lastMissionAt?.toIso8601String(),
      'missions_completed': missionsCompleted,
      'missions_failed': missionsFailed,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // حساب الكفاءة العامة
  double get efficiency {
    return ((energy + morale + health) / 3).clamp(0.0, 100.0);
  }

  // مستوى الإجهاد
  String get stressLevelText {
    if (stressLevel >= 80) return 'إجهاد شديد';
    if (stressLevel >= 60) return 'إجهاد متوسط';
    if (stressLevel >= 40) return 'إجهاد خفيف';
    return 'مستقر';
  }

  // لون مستوى الإجهاد
  String get stressColor {
    if (stressLevel >= 80) return '#F44336'; // أحمر
    if (stressLevel >= 60) return '#FF9800'; // برتقالي
    if (stressLevel >= 40) return '#FFC107'; // أصفر
    return '#4CAF50'; // أخضر
  }

  // مستوى الخبرة
  String get experienceText {
    if (experienceLevel >= 5) return 'خبير';
    if (experienceLevel >= 4) return 'متقدم';
    if (experienceLevel >= 3) return 'متوسط';
    if (experienceLevel >= 2) return 'مبتدئ';
    return 'جديد';
  }

  // النقاط المطلوبة للمستوى التالي
  int get xpToNextLevel {
    return (currentLevel + 1) * 100;
  }

  // نسبة التقدم للمستوى التالي
  double get progressToNextLevel {
    int currentLevelXp = currentLevel * 100;
    int currentProgress = xp - currentLevelXp;
    return (currentProgress / 100).clamp(0.0, 1.0);
  }

  // هل الشخصية متاحة للعمل؟
  bool get isAvailableForWork {
    return status == AvatarStatus.available &&
        energy > 20 &&
        health > 30 &&
        stressLevel < 80;
  }

  // الوصف التفصيلي للحالة
  String get statusDescription {
    if (!isAvailableForWork) {
      if (energy <= 20) return 'طاقة منخفضة';
      if (health <= 30) return 'حالة صحية سيئة';
      if (stressLevel >= 80) return 'إجهاد شديد';
      return 'غير متاح';
    }
    return status.displayName;
  }

  // أيقونة نوع الشخصية
  String get typeIcon {
    switch (type) {
      case AvatarType.staff:
        return '👨‍⚕️';
      case AvatarType.patient:
        return '🤒';
    }
  }

  // تحديث حالة الشخصية
  GameAvatar copyWith({
    AvatarStatus? status,
    int? energy,
    int? morale,
    int? health,
    int? stressLevel,
    int? xp,
    int? currentLevel,
    DateTime? lastMissionAt,
    int? missionsCompleted,
    int? missionsFailed,
  }) {
    return GameAvatar(
      id: id,
      userId: userId,
      avatarName: avatarName,
      type: type,
      status: status ?? this.status,
      specialty: specialty,
      experienceLevel: experienceLevel,
      skills: skills,
      appearance: appearance,
      isActive: isActive,
      isNPC: isNPC,
      backgroundStory: backgroundStory,
      reputation: reputation,
      energy: energy ?? this.energy,
      morale: morale ?? this.morale,
      health: health ?? this.health,
      currentLevel: currentLevel ?? this.currentLevel,
      xp: xp ?? this.xp,
      stressLevel: stressLevel ?? this.stressLevel,
      lastMissionAt: lastMissionAt ?? this.lastMissionAt,
      missionsCompleted: missionsCompleted ?? this.missionsCompleted,
      missionsFailed: missionsFailed ?? this.missionsFailed,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

enum AvatarType { staff, patient }

enum AvatarStatus { available, busy, resting, unavailable }

extension AvatarTypeExtension on AvatarType {
  String get displayName {
    switch (this) {
      case AvatarType.staff:
        return 'طاقم طبي';
      case AvatarType.patient:
        return 'مريض';
    }
  }

  String get color {
    switch (this) {
      case AvatarType.staff:
        return '#2196F3'; // أزرق
      case AvatarType.patient:
        return '#FF9800'; // برتقالي
    }
  }

  String get icon {
    switch (this) {
      case AvatarType.staff:
        return '👨‍⚕️';
      case AvatarType.patient:
        return '🤒';
    }
  }
}

extension AvatarStatusExtension on AvatarStatus {
  String get displayName {
    switch (this) {
      case AvatarStatus.available:
        return 'متاح';
      case AvatarStatus.busy:
        return 'مشغول';
      case AvatarStatus.resting:
        return 'يستريح';
      case AvatarStatus.unavailable:
        return 'غير متاح';
    }
  }

  String get color {
    switch (this) {
      case AvatarStatus.available:
        return '#4CAF50'; // أخضر
      case AvatarStatus.busy:
        return '#FF5722'; // أحمر برتقالي
      case AvatarStatus.resting:
        return '#FF9800'; // برتقالي
      case AvatarStatus.unavailable:
        return '#9E9E9E'; // رمادي
    }
  }

  String get icon {
    switch (this) {
      case AvatarStatus.available:
        return '✅';
      case AvatarStatus.busy:
        return '⏱️';
      case AvatarStatus.resting:
        return '😴';
      case AvatarStatus.unavailable:
        return '❌';
    }
  }
}
