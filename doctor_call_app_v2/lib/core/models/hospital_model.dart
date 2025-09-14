class Hospital {
  final int id;
  final String name;
  final String location;
  final String phoneNumber;
  final String email;
  final int capacity;
  final int availableBeds;
  final String specialization;
  final String description;
  final String status;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Hospital({
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.email,
    required this.capacity,
    required this.availableBeds,
    required this.specialization,
    this.description = '',
    this.status = 'active',
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      capacity: json['capacity'] ?? 0,
      availableBeds: json['available_beds'] ?? 0,
      specialization: json['specialization'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'active',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone_number': phoneNumber,
      'email': email,
      'capacity': capacity,
      'available_beds': availableBeds,
      'specialization': specialization,
      'description': description,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Hospital copyWith({
    int? id,
    String? name,
    String? location,
    String? phoneNumber,
    String? email,
    int? capacity,
    int? availableBeds,
    String? specialization,
    String? description,
    String? status,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hospital(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      capacity: capacity ?? this.capacity,
      availableBeds: availableBeds ?? this.availableBeds,
      specialization: specialization ?? this.specialization,
      description: description ?? this.description,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  int get occupiedBeds => capacity - availableBeds;

  double get occupancyRate =>
      capacity > 0 ? (occupiedBeds / capacity) * 100 : 0.0;

  bool get isActive => status.toLowerCase() == 'active';

  bool get hasAvailableBeds => availableBeds > 0;

  String get occupancyStatus {
    if (occupancyRate >= 90) return 'critical';
    if (occupancyRate >= 75) return 'high';
    if (occupancyRate >= 50) return 'medium';
    return 'low';
  }

  @override
  String toString() {
    return 'Hospital{id: $id, name: $name, location: $location, capacity: $capacity, available: $availableBeds}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hospital && other.id == id && other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode;
  }
}
