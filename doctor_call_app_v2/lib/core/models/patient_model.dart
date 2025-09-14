class Patient {
  final int id;
  final String name;
  final String nationalId;
  final String phoneNumber;
  final int age;
  final String gender;
  final String status;
  final String medicalHistory;
  final String priority;
  final DateTime? admissionDate;
  final int? hospitalId;
  final String? assignedDoctor;

  Patient({
    required this.id,
    required this.name,
    required this.nationalId,
    required this.phoneNumber,
    required this.age,
    required this.gender,
    required this.status,
    this.medicalHistory = '',
    this.priority = 'normal',
    this.admissionDate,
    this.hospitalId,
    this.assignedDoctor,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nationalId: json['national_id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      medicalHistory: json['medical_history'] ?? '',
      priority: json['priority'] ?? 'normal',
      admissionDate: json['admission_date'] != null 
          ? DateTime.parse(json['admission_date']) 
          : null,
      hospitalId: json['hospital_id'],
      assignedDoctor: json['assigned_doctor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'national_id': nationalId,
      'phone_number': phoneNumber,
      'age': age,
      'gender': gender,
      'status': status,
      'medical_history': medicalHistory,
      'priority': priority,
      'admission_date': admissionDate?.toIso8601String(),
      'hospital_id': hospitalId,
      'assigned_doctor': assignedDoctor,
    };
  }

  Patient copyWith({
    int? id,
    String? name,
    String? nationalId,
    String? phoneNumber,
    int? age,
    String? gender,
    String? status,
    String? medicalHistory,
    String? priority,
    DateTime? admissionDate,
    int? hospitalId,
    String? assignedDoctor,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      nationalId: nationalId ?? this.nationalId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      status: status ?? this.status,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      priority: priority ?? this.priority,
      admissionDate: admissionDate ?? this.admissionDate,
      hospitalId: hospitalId ?? this.hospitalId,
      assignedDoctor: assignedDoctor ?? this.assignedDoctor,
    );
  }

  @override
  String toString() {
    return 'Patient{id: $id, name: $name, nationalId: $nationalId, status: $status}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Patient &&
        other.id == id &&
        other.nationalId == nationalId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nationalId.hashCode;
  }
}