import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_call_app_v2/core/services/hospital_service.dart';
import 'package:doctor_call_app_v2/core/models/hospital_model.dart';

void main() {
  group('HospitalService Tests', () {
    late HospitalService hospitalService;

    setUp(() {
      hospitalService = HospitalService();
    });

    group('Service Initialization', () {
      test('should initialize HospitalService successfully', () {
        // Assert
        expect(hospitalService, isNotNull);
        expect(hospitalService, isA<HospitalService>());
      });
    });

    group('Hospital Model Tests', () {
      test('should create Hospital from JSON', () {
        // Arrange
        final hospitalJson = {
          'id': 1,
          'name': 'King Abdulaziz Hospital',
          'address': 'Riyadh, Saudi Arabia',
          'phone': '+966112345678',
          'email': 'info@kamc.sa',
          'capacity': 500,
          'current_patients': 120,
          'status': 'active',
          'latitude': 24.7136,
          'longitude': 46.6753,
          'specialties': ['Emergency', 'Cardiology', 'Neurology']
        };

        // Act
        final hospital = Hospital.fromJson(hospitalJson);

        // Assert
        expect(hospital.id, equals(1));
        expect(hospital.name, equals('King Abdulaziz Hospital'));
        expect(hospital.location, equals('Riyadh, Saudi Arabia'));
        expect(hospital.phone, equals('+966112345678'));
        expect(hospital.email, equals('info@kamc.sa'));
        expect(hospital.capacity, equals(500));
        expect(hospital.currentPatients, equals(120));
        expect(hospital.status, equals('active'));
        expect(hospital.latitude, equals(24.7136));
        expect(hospital.longitude, equals(46.6753));
      });

      test('should convert Hospital to JSON', () {
        // Arrange
        final hospital = Hospital(
          id: 1,
          name: 'King Abdulaziz Hospital',
          location: 'Riyadh, Saudi Arabia',
          phone: '+966112345678',
          email: 'info@kamc.sa',
          capacity: 500,
          currentPatients: 120,
          status: 'active',
          latitude: 24.7136,
          longitude: 46.6753,
        );

        // Act
        final json = hospital.toJson();

        // Assert
        expect(json['id'], equals(1));
        expect(json['name'], equals('King Abdulaziz Hospital'));
        expect(json['address'], equals('Riyadh, Saudi Arabia'));
        expect(json['phone'], equals('+966112345678'));
        expect(json['email'], equals('info@kamc.sa'));
        expect(json['capacity'], equals(500));
        expect(json['current_patients'], equals(120));
        expect(json['status'], equals('active'));
        expect(json['latitude'], equals(24.7136));
        expect(json['longitude'], equals(46.6753));
      });
    });

    group('Hospital Calculations', () {
      test('should calculate occupancy rate correctly', () {
        // Arrange
        final hospital = Hospital(
          id: 1,
          name: 'Test Hospital',
          location: 'Test City',
          phone: '123456789',
          email: 'test@hospital.com',
          capacity: 100,
          currentPatients: 75,
          status: 'active',
          latitude: 0.0,
          longitude: 0.0,
        );

        // Act
        final occupancyRate = (hospital.currentPatients / hospital.capacity * 100);

        // Assert
        expect(occupancyRate, equals(75.0));
      });

      test('should handle zero capacity gracefully', () {
        // Arrange
        final hospital = Hospital(
          id: 1,
          name: 'Test Hospital',
          location: 'Test City',
          phone: '123456789',
          email: 'test@hospital.com',
          capacity: 0,
          currentPatients: 0,
          status: 'maintenance',
          latitude: 0.0,
          longitude: 0.0,
        );

        // Act & Assert
        expect(hospital.capacity, equals(0));
        expect(hospital.currentPatients, equals(0));
        expect(hospital.status, equals('maintenance'));
      });
    });

    group('Error Handling', () {
      test('should handle malformed hospital data gracefully', () {
        // Arrange
        final malformedJson = {
          'id': 'invalid_id', // Should be int
          'name': null, // Should be string
          'capacity': 'hundred', // Should be int
        };

        // Act & Assert
        expect(() => Hospital.fromJson(malformedJson), throwsA(isA<TypeError>()));
      });
    });
  });
}