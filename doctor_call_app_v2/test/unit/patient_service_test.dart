import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_call_app_v2/core/services/patient_service.dart';
import 'package:doctor_call_app_v2/core/models/patient_model.dart';

void main() {
  group('PatientService Tests', () {
    late PatientService patientService;

    setUp(() {
      patientService = PatientService();
    });

    group('Service Initialization', () {
      test('should initialize PatientService successfully', () {
        // Assert
        expect(patientService, isNotNull);
        expect(patientService, isA<PatientService>());
      });
    });

    group('Patient Model Tests', () {
      test('should create Patient from JSON', () {
        // Arrange
        final patientJson = {
          'id': 1,
          'name': 'Ahmed Ali',
          'national_id': '1234567890',
          'phone_number': '0501234567',
          'age': 30,
          'gender': 'male',
          'status': 'waiting',
          'medical_history': 'No known allergies',
          'priority': 'normal',
          'admission_date': '2024-01-15T10:30:00Z',
          'hospital_id': 1,
          'assigned_doctor': 'Dr. Smith'
        };

        // Act
        final patient = Patient.fromJson(patientJson);

        // Assert
        expect(patient.id, equals(1));
        expect(patient.name, equals('Ahmed Ali'));
        expect(patient.nationalId, equals('1234567890'));
        expect(patient.phoneNumber, equals('0501234567'));
        expect(patient.age, equals(30));
        expect(patient.gender, equals('male'));
        expect(patient.status, equals('waiting'));
        expect(patient.priority, equals('normal'));
        expect(patient.hospitalId, equals(1));
        expect(patient.assignedDoctor, equals('Dr. Smith'));
      });

      test('should convert Patient to JSON', () {
        // Arrange
        final patient = Patient(
          id: 1,
          name: 'Ahmed Ali',
          nationalId: '1234567890',
          phoneNumber: '0501234567',
          age: 30,
          gender: 'male',
          status: 'waiting',
          medicalHistory: 'No known allergies',
          priority: 'normal',
          hospitalId: 1,
          assignedDoctor: 'Dr. Smith',
        );

        // Act
        final json = patient.toJson();

        // Assert
        expect(json['id'], equals(1));
        expect(json['name'], equals('Ahmed Ali'));
        expect(json['national_id'], equals('1234567890'));
        expect(json['phone_number'], equals('0501234567'));
        expect(json['age'], equals(30));
        expect(json['gender'], equals('male'));
        expect(json['status'], equals('waiting'));
        expect(json['priority'], equals('normal'));
        expect(json['hospital_id'], equals(1));
        expect(json['assigned_doctor'], equals('Dr. Smith'));
      });
    });

    group('Error Handling', () {
      test('should handle malformed patient data gracefully', () {
        // Arrange
        final malformedJson = {
          'id': 'invalid_id', // Should be int
          'name': null, // Should be string
          'age': 'thirty', // Should be int
        };

        // Act & Assert
        expect(() => Patient.fromJson(malformedJson), throwsA(isA<TypeError>()));
      });
    });
  });
}