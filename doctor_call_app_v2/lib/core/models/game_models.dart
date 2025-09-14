class Achievement {
  final int id;
  final String name;
  final String description;
  final String iconUrl;
  final int requiredPoints;
  final String category;
  final Map<String, dynamic> requirements;
  final DateTime? unlockedAt;
  final bool isUnlocked;
  final String rarity; // common, rare, epic, legendary
  final List<String> rewards;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.requiredPoints,
    required this.category,
    required this.requirements,
    this.unlockedAt,
    this.isUnlocked = false,
    this.rarity = 'common',
    this.rewards = const [],
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      requiredPoints: json['required_points'] ?? 0,
      category: json['category'] ?? '',
      requirements: Map<String, dynamic>.from(json['requirements'] ?? {}),
      unlockedAt: json['unlocked_at'] != null 
          ? DateTime.parse(json['unlocked_at']) 
          : null,
      isUnlocked: json['is_unlocked'] ?? false,
      rarity: json['rarity'] ?? 'common',
      rewards: List<String>.from(json['rewards'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'required_points': requiredPoints,
      'category': category,
      'requirements': requirements,
      'unlocked_at': unlockedAt?.toIso8601String(),
      'is_unlocked': isUnlocked,
      'rarity': rarity,
      'rewards': rewards,
    };
  }

  Achievement copyWith({
    int? id,
    String? name,
    String? description,
    String? iconUrl,
    int? requiredPoints,
    String? category,
    Map<String, dynamic>? requirements,
    DateTime? unlockedAt,
    bool? isUnlocked,
    String? rarity,
    List<String>? rewards,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      category: category ?? this.category,
      requirements: requirements ?? this.requirements,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      rarity: rarity ?? this.rarity,
      rewards: rewards ?? this.rewards,
    );
  }

  @override
  String toString() {
    return 'Achievement{id: $id, name: $name, isUnlocked: $isUnlocked}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Achievement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class GameScore {
  final int totalPoints;
  final int level;
  final int experiencePoints;
  final int nextLevelPoints;
  final Map<String, int> categoryPoints;
  final List<Achievement> unlockedAchievements;
  final int rank;
  final String title;

  GameScore({
    required this.totalPoints,
    required this.level,
    required this.experiencePoints,
    required this.nextLevelPoints,
    required this.categoryPoints,
    required this.unlockedAchievements,
    this.rank = 0,
    this.title = 'مبتدئ',
  });

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      totalPoints: json['total_points'] ?? 0,
      level: json['level'] ?? 1,
      experiencePoints: json['experience_points'] ?? 0,
      nextLevelPoints: json['next_level_points'] ?? 100,
      categoryPoints: Map<String, int>.from(json['category_points'] ?? {}),
      unlockedAchievements: (json['unlocked_achievements'] as List<dynamic>?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
      rank: json['rank'] ?? 0,
      title: json['title'] ?? 'مبتدئ',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_points': totalPoints,
      'level': level,
      'experience_points': experiencePoints,
      'next_level_points': nextLevelPoints,
      'category_points': categoryPoints,
      'unlocked_achievements': unlockedAchievements.map((a) => a.toJson()).toList(),
      'rank': rank,
      'title': title,
    };
  }

  double get progressToNextLevel {
    final currentLevelStart = (level - 1) * 100;
    final nextLevelStart = level * 100;
    final progress = experiencePoints - currentLevelStart;
    final total = nextLevelStart - currentLevelStart;
    return total > 0 ? progress / total : 0.0;
  }

  int get pointsToNextLevel => nextLevelPoints - experiencePoints;

  GameScore copyWith({
    int? totalPoints,
    int? level,
    int? experiencePoints,
    int? nextLevelPoints,
    Map<String, int>? categoryPoints,
    List<Achievement>? unlockedAchievements,
    int? rank,
    String? title,
  }) {
    return GameScore(
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      nextLevelPoints: nextLevelPoints ?? this.nextLevelPoints,
      categoryPoints: categoryPoints ?? this.categoryPoints,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      rank: rank ?? this.rank,
      title: title ?? this.title,
    );
  }
}

class LeaderboardEntry {
  final int userId;
  final String userName;
  final String userAvatar;
  final int totalPoints;
  final int level;
  final int rank;
  final String title;
  final Map<String, int> categoryPoints;
  final List<Achievement> recentAchievements;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.totalPoints,
    required this.level,
    required this.rank,
    required this.title,
    required this.categoryPoints,
    required this.recentAchievements,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'] ?? '',
      totalPoints: json['total_points'] ?? 0,
      level: json['level'] ?? 1,
      rank: json['rank'] ?? 0,
      title: json['title'] ?? '',
      categoryPoints: Map<String, int>.from(json['category_points'] ?? {}),
      recentAchievements: (json['recent_achievements'] as List<dynamic>?)
          ?.map((a) => Achievement.fromJson(a))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'total_points': totalPoints,
      'level': level,
      'rank': rank,
      'title': title,
      'category_points': categoryPoints,
      'recent_achievements': recentAchievements.map((a) => a.toJson()).toList(),
    };
  }
}

class GameAction {
  final String type;
  final String description;
  final int points;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  GameAction({
    required this.type,
    required this.description,
    required this.points,
    required this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory GameAction.fromJson(Map<String, dynamic> json) {
    return GameAction(
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'description': description,
      'points': points,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// Predefined game action types
class GameActionType {
  static const String patientAdmitted = 'patient_admitted';
  static const String patientDischarged = 'patient_discharged';
  static const String emergencyHandled = 'emergency_handled';
  static const String hospitalManaged = 'hospital_managed';
  static const String missionCompleted = 'mission_completed';
  static const String fastResponse = 'fast_response';
  static const String accurateDiagnosis = 'accurate_diagnosis';
  static const String teamCollaboration = 'team_collaboration';
  static const String patientSatisfaction = 'patient_satisfaction';
  static const String systemImprovement = 'system_improvement';
}

// Achievement categories
class AchievementCategory {
  static const String patient = 'patient';
  static const String emergency = 'emergency';
  static const String hospital = 'hospital';
  static const String teamwork = 'teamwork';
  static const String efficiency = 'efficiency';
  static const String learning = 'learning';
  static const String innovation = 'innovation';
  static const String leadership = 'leadership';
}