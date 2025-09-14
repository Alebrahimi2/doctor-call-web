class UserModel {
  final String id; // Changed to String to support both int and string IDs
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String role;
  final String? department;
  final String? specialization;
  final String? profileImage;
  final String? emailVerifiedAt; // Changed to String for easier parsing
  final String? createdAt; // Changed to String for easier parsing
  final String? updatedAt; // Changed to String for easier parsing
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.role,
    this.department,
    this.specialization,
    this.profileImage,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '0',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String? ?? 'patient',
      department: json['department'] as String?,
      specialization: json['specialization'] as String?,
      profileImage: json['profile_image'] as String?,
      emailVerifiedAt: json['email_verified_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'role': role,
      'department': department,
      'specialization': specialization,
      'profile_image': profileImage,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
    };
  }

  // Copy with method for updating user data
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? role,
    String? department,
    String? specialization,
    String? profileImage,
    String? emailVerifiedAt,
    String? createdAt,
    String? updatedAt,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      department: department ?? this.department,
      specialization: specialization ?? this.specialization,
      profileImage: profileImage ?? this.profileImage,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role)';
  }

  // Getter methods
  bool get isAdmin => role == 'admin';
  bool get isDoctor => role == 'doctor';
  bool get isNurse => role == 'nurse';
  bool get isPatient => role == 'patient';
  bool get isEmailVerified => emailVerifiedAt != null;

  String get displayName => name;
  String get avatarUrl => avatar ?? '';
}

// AuthResult class for handling authentication responses
class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;
  final String? token;
  final Map<String, dynamic>? data;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.token,
    this.data,
  });

  factory AuthResult.success(UserModel user, String token) {
    return AuthResult(
      success: true,
      message: 'تم تسجيل الدخول بنجاح',
      user: user,
      token: token,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(success: false, message: message);
  }

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      token: json['token'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
      'token': token,
      'data': data,
    };
  }
}
