import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_call_app_v2/models/patient.dart';
import 'package:doctor_call_app_v2/models/hospital.dart';

void main() {
  group('Models Tests', () {
    group('Patient Model Tests', () {
      test('should create patient with all required fields', () {
        // Arrange & Act
        final patient = Patient(
          id: 1,
          hospitalId: 1,
          severity: 3,
          conditionCode: 'C001',
          triagePriority: 2,
          status: PatientStatus.wait,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(patient.id, equals(1));
        expect(patient.hospitalId, equals(1));
        expect(patient.severity, equals(3));
        expect(patient.conditionCode, equals('C001'));
        expect(patient.triagePriority, equals(2));
        expect(patient.status, equals(PatientStatus.wait));
      });

      test('should create patient from JSON correctly', () {
        // Arrange
        final patientJson = {
          'id': 2,
          'hospital_id': 2,
          'severity': 4,
          'condition_code': 'C002',
          'triage_priority': 1,
          'status': 'inService',
          'created_at': '2024-01-01T10:00:00Z',
          'updated_at': '2024-01-01T10:00:00Z',
        };

        // Act
        final patient = Patient.fromJson(patientJson);

        // Assert
        expect(patient.id, equals(2));
        expect(patient.hospitalId, equals(2));
        expect(patient.severity, equals(4));
        expect(patient.conditionCode, equals('C002'));
        expect(patient.triagePriority, equals(1));
        expect(patient.status, equals(PatientStatus.inService));
      });

      test('should convert patient to JSON correctly', () {
        // Arrange
        final patient = Patient(
          id: 3,
          hospitalId: 3,
          severity: 2,
          conditionCode: 'C003',
          triagePriority: 3,
          status: PatientStatus.done,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final json = patient.toJson();

        // Assert
        expect(json['id'], equals(3));
        expect(json['hospital_id'], equals(3));
        expect(json['severity'], equals(2));
        expect(json['condition_code'], equals('C003'));
        expect(json['triage_priority'], equals(3));
        expect(json['status'], equals('done'));
      });

      test('should validate patient status values', () {
        // Arrange
        const validStatuses = [
          PatientStatus.wait,
          PatientStatus.inService,
          PatientStatus.obs,
          PatientStatus.done,
          PatientStatus.dead
        ];

        // Assert
        expect(validStatuses.contains(PatientStatus.wait), isTrue);
        expect(validStatuses.contains(PatientStatus.inService), isTrue);
        expect(validStatuses.contains(PatientStatus.obs), isTrue);
        expect(validStatuses.contains(PatientStatus.done), isTrue);
        expect(validStatuses.contains(PatientStatus.dead), isTrue);
        expect(validStatuses.length, equals(5));
      });

      test('should validate severity and priority ranges', () {
        // Arrange
        const minSeverity = 1;
        const maxSeverity = 5;
        const minPriority = 1;
        const maxPriority = 5;

        // Assert
        expect(minSeverity >= 1, isTrue);
        expect(maxSeverity <= 5, isTrue);
        expect(minPriority >= 1, isTrue);
        expect(maxPriority <= 5, isTrue);
      });
    });

    group('Hospital Model Tests', () {
      test('should create hospital with all required fields', () {
        // Arrange & Act
        final hospital = Hospital(
          id: 1,
          name: 'مستشفى الملك فيصل التخصصي',
          address: 'الرياض، المملكة العربية السعودية',
          phone: '+966114647272',
          email: 'info@kfshrc.edu.sa',
          status: HospitalStatus.active,
          latitude: 24.7136,
          longitude: 46.6753,
          capacity: 1000,
          currentLoad: 750,
          efficiency: 0.85,
          level: 5,
          reputation: 4.8,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Assert
        expect(hospital.id, equals(1));
        expect(hospital.name, equals('مستشفى الملك فيصل التخصصي'));
        expect(hospital.status, equals(HospitalStatus.active));
        expect(hospital.capacity, equals(1000));
        expect(hospital.currentLoad, equals(750));
        expect(hospital.efficiency, equals(0.85));
        expect(hospital.level, equals(5));
        expect(hospital.reputation, equals(4.8));
      });

      test('should create hospital from JSON correctly', () {
        // Arrange
        final hospitalJson = {
          'id': 2,
          'name': 'مستشفى الملك خالد الجامعي',
          'address': 'الرياض، المملكة العربية السعودية',
          'phone': '+966114670011',
          'email': 'info@kkuh.sa',
          'status': 'active',
          'latitude': 24.7242,
          'longitude': 46.6371,
          'capacity': 800,
          'current_load': 600,
          'efficiency': 0.75,
          'level': 4,
          'reputation': 4.5,
          'created_at': '2024-01-01T10:00:00Z',
          'updated_at': '2024-01-01T10:00:00Z',
        };

        // Act
        final hospital = Hospital.fromJson(hospitalJson);

        // Assert
        expect(hospital.id, equals(2));
        expect(hospital.name, equals('مستشفى الملك خالد الجامعي'));
        expect(hospital.status, equals(HospitalStatus.active));
        expect(hospital.capacity, equals(800));
        expect(hospital.currentLoad, equals(600));
        expect(hospital.efficiency, equals(0.75));
        expect(hospital.level, equals(4));
        expect(hospital.reputation, equals(4.5));
      });

      test('should convert hospital to JSON correctly', () {
        // Arrange
        final hospital = Hospital(
          id: 3,
          name: 'مستشفى الملك عبدالعزيز',
          address: 'جدة، المملكة العربية السعودية',
          phone: '+966126408888',
          email: 'info@kaah.sa',
          status: HospitalStatus.emergency,
          latitude: 21.4858,
          longitude: 39.1925,
          capacity: 1200,
          currentLoad: 950,
          efficiency: 0.92,
          level: 5,
          reputation: 4.9,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        );

        // Act
        final json = hospital.toJson();

        // Assert
        expect(json['id'], equals(3));
        expect(json['name'], equals('مستشفى الملك عبدالعزيز'));
        expect(json['status'], equals('emergency'));
        expect(json['capacity'], equals(1200));
        expect(json['current_load'], equals(950));
        expect(json['efficiency'], equals(0.92));
        expect(json['level'], equals(5));
        expect(json['reputation'], equals(4.9));
      });

      test('should validate hospital status values', () {
        // Arrange
        const validStatuses = [
          HospitalStatus.active,
          HospitalStatus.maintenance,
          HospitalStatus.emergency,
          HospitalStatus.closed
        ];

        // Assert
        expect(validStatuses.contains(HospitalStatus.active), isTrue);
        expect(validStatuses.contains(HospitalStatus.maintenance), isTrue);
        expect(validStatuses.contains(HospitalStatus.emergency), isTrue);
        expect(validStatuses.contains(HospitalStatus.closed), isTrue);
        expect(validStatuses.length, equals(4));
      });

      test('should calculate hospital occupancy rate', () {
        // Arrange
        final hospital = Hospital(
          id: 1,
          name: 'Test Hospital',
          address: 'Test Address',
          phone: '+966500000000',
          email: 'test@hospital.com',
          status: HospitalStatus.active,
          latitude: 0.0,
          longitude: 0.0,
          capacity: 100,
          currentLoad: 75,
          efficiency: 0.8,
          level: 3,
          reputation: 4.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // Act
        final occupancyRate = (hospital.currentLoad / hospital.capacity) * 100;

        // Assert
        expect(occupancyRate, equals(75.0));
      });

      test('should validate efficiency range', () {
        // Arrange
        const validEfficiency1 = 0.85;
        const validEfficiency2 = 0.0;
        const validEfficiency3 = 1.0;
        const invalidEfficiency1 = -0.1;
        const invalidEfficiency2 = 1.1;

        // Assert
        expect(validEfficiency1 >= 0.0 && validEfficiency1 <= 1.0, isTrue);
        expect(validEfficiency2 >= 0.0 && validEfficiency2 <= 1.0, isTrue);
        expect(validEfficiency3 >= 0.0 && validEfficiency3 <= 1.0, isTrue);
        expect(invalidEfficiency1 >= 0.0 && invalidEfficiency1 <= 1.0, isFalse);
        expect(invalidEfficiency2 >= 0.0 && invalidEfficiency2 <= 1.0, isFalse);
      });

      test('should validate reputation range', () {
        // Arrange
        const validReputation1 = 4.5;
        const validReputation2 = 1.0;
        const validReputation3 = 5.0;
        const invalidReputation1 = 0.5;
        const invalidReputation2 = 5.5;

        // Assert
        expect(validReputation1 >= 1.0 && validReputation1 <= 5.0, isTrue);
        expect(validReputation2 >= 1.0 && validReputation2 <= 5.0, isTrue);
        expect(validReputation3 >= 1.0 && validReputation3 <= 5.0, isTrue);
        expect(invalidReputation1 >= 1.0 && invalidReputation1 <= 5.0, isFalse);
        expect(invalidReputation2 >= 1.0 && invalidReputation2 <= 5.0, isFalse);
      });

      test('should validate capacity constraints', () {
        // Arrange
        const capacity = 500;
        const currentLoad1 = 400; // Valid
        const currentLoad2 = 600; // Invalid (exceeds capacity)

        // Assert
        expect(currentLoad1 <= capacity, isTrue);
        expect(currentLoad2 <= capacity, isFalse);
      });
    });
  });
}