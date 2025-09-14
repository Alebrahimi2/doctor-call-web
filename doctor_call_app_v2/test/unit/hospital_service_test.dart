import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:doctor_call_app_v2/core/services/hospital_service.dart';
import 'package:doctor_call_app_v2/core/models/hospital_model.dart';
import '../mocks/mock_data.dart';

// Generate mock classes
@GenerateMocks([http.Client])
import 'hospital_service_test.mocks.dart';

void main() {
  group('HospitalService Tests', () {
    late HospitalService hospitalService;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      hospitalService = HospitalService();
      // Inject mock client into hospital service
    });

    group('getHospitals', () {
      test('should return list of hospitals', () async {
        // Arrange
        const token = 'valid_token_123';
        
        final mockResponse = {
          'success': true,
          'data': {
            'hospitals': MockData.mockHospitals.map((h) => h.toJson()).toList(),
            'total_count': MockData.mockHospitals.length,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitals(token);

        // Assert
        expect(result['success'], true);
        expect(result['data']['hospitals'], isA<List>());
        expect(result['data']['hospitals'].length, MockData.mockHospitals.length);
      });

      test('should handle empty hospital list', () async {
        // Arrange
        const token = 'valid_token_123';
        
        final mockResponse = {
          'success': true,
          'data': {
            'hospitals': [],
            'total_count': 0,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitals(token);

        // Assert
        expect(result['success'], true);
        expect(result['data']['hospitals'], isEmpty);
      });
    });

    group('getHospitalById', () {
      test('should return hospital details', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        final mockHospital = MockData.mockHospitals.first;
        
        final mockResponse = {
          'success': true,
          'data': mockHospital.toJson(),
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitalById(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['id'], hospitalId);
        expect(result['data']['name'], mockHospital.name);
        expect(result['data']['departments'], isA<List>());
      });

      test('should handle hospital not found', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 999;
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(MockData.mockNotFoundError),
          404,
        ));

        // Act
        final result = await hospitalService.getHospitalById(token, hospitalId);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 404);
      });
    });

    group('getHospitalStatistics', () {
      test('should return hospital statistics', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        
        final mockResponse = {
          'success': true,
          'data': {
            'hospital_id': hospitalId,
            'total_patients': 245,
            'active_patients': 18,
            'completed_today': 32,
            'total_doctors': 15,
            'available_doctors': 8,
            'departments_count': 6,
            'average_wait_time': 22, // minutes
            'patient_satisfaction': 4.3, // out of 5
            'occupancy_rate': 0.75,
            'department_stats': [
              {
                'department': 'الطوارئ',
                'waiting_patients': 5,
                'in_treatment': 3,
                'available_doctors': 2,
              },
              {
                'department': 'الباطنة',
                'waiting_patients': 8,
                'in_treatment': 4,
                'available_doctors': 3,
              },
            ],
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitalStatistics(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['hospital_id'], hospitalId);
        expect(result['data']['total_patients'], 245);
        expect(result['data']['department_stats'], isA<List>());
      });
    });

    group('getHospitalDoctors', () {
      test('should return list of doctors in hospital', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        
        final mockResponse = {
          'success': true,
          'data': {
            'doctors': [
              {
                'id': 1,
                'name': 'د. أحمد محمد',
                'specialization': 'طب الباطنة',
                'status': 'available',
                'current_patients': 3,
                'max_patients': 8,
                'department': 'الباطنة',
              },
              {
                'id': 2,
                'name': 'د. فاطمة علي',
                'specialization': 'طب الطوارئ',
                'status': 'busy',
                'current_patients': 5,
                'max_patients': 6,
                'department': 'الطوارئ',
              },
            ],
            'total_doctors': 15,
            'available_doctors': 8,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitalDoctors(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['doctors'], isA<List>());
        expect(result['data']['doctors'].length, 2);
        expect(result['data']['total_doctors'], 15);
      });

      test('should filter doctors by availability', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        const availableOnly = true;
        
        final mockResponse = {
          'success': true,
          'data': {
            'doctors': [
              {
                'id': 1,
                'name': 'د. أحمد محمد',
                'specialization': 'طب الباطنة',
                'status': 'available',
                'current_patients': 3,
                'max_patients': 8,
                'department': 'الباطنة',
              },
            ],
            'total_doctors': 8,
            'available_doctors': 8,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getAvailableDoctors(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['doctors'], isA<List>());
        // All returned doctors should be available
        for (var doctor in result['data']['doctors']) {
          expect(doctor['status'], 'available');
        }
      });
    });

    group('getHospitalDepartments', () {
      test('should return hospital departments', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        
        final mockResponse = {
          'success': true,
          'data': {
            'departments': [
              {
                'id': 1,
                'name': 'الطوارئ',
                'description': 'قسم الطوارئ والحالات الحرجة',
                'head_doctor': 'د. فاطمة علي',
                'capacity': 20,
                'current_patients': 15,
                'doctors_count': 6,
                'status': 'active',
              },
              {
                'id': 2,
                'name': 'الباطنة',
                'description': 'قسم الطب الباطني',
                'head_doctor': 'د. أحمد محمد',
                'capacity': 30,
                'current_patients': 22,
                'doctors_count': 8,
                'status': 'active',
              },
            ],
            'total_departments': 6,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitalDepartments(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['departments'], isA<List>());
        expect(result['data']['departments'].length, 2);
        expect(result['data']['total_departments'], 6);
      });
    });

    group('updateHospitalInfo', () {
      test('should update hospital information', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        final updateData = {
          'name': 'مستشفى الملك فهد الجديد',
          'address': 'الرياض، حي النخيل',
          'phone': '+966112345678',
          'emergency_phone': '+966112345679',
        };
        
        final mockResponse = {
          'success': true,
          'message': 'تم تحديث بيانات المستشفى بنجاح',
          'data': {
            'id': hospitalId,
            'name': updateData['name'],
            'address': updateData['address'],
            'phone': updateData['phone'],
            'emergency_phone': updateData['emergency_phone'],
            'updated_at': DateTime.now().toIso8601String(),
          },
        };
        
        when(mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.updateHospitalInfo(token, hospitalId, updateData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['name'], updateData['name']);
        expect(result['data']['address'], updateData['address']);
      });

      test('should handle validation errors', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        final invalidUpdateData = {
          'phone': 'invalid_phone_number',
        };
        
        when(mockHttpClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(MockData.mockValidationError),
          422,
        ));

        // Act
        final result = await hospitalService.updateHospitalInfo(token, hospitalId, invalidUpdateData);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 422);
        expect(result['errors'], isNotNull);
      });
    });

    group('createDepartment', () {
      test('should create new department', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        final departmentData = {
          'name': 'قسم الأطفال',
          'description': 'قسم طب الأطفال وحديثي الولادة',
          'capacity': 25,
          'head_doctor_id': 3,
        };
        
        final mockResponse = {
          'success': true,
          'message': 'تم إنشاء القسم بنجاح',
          'data': {
            'id': 7,
            'name': departmentData['name'],
            'description': departmentData['description'],
            'capacity': departmentData['capacity'],
            'hospital_id': hospitalId,
            'head_doctor_id': departmentData['head_doctor_id'],
            'status': 'active',
            'created_at': DateTime.now().toIso8601String(),
          },
        };
        
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          201,
        ));

        // Act
        final result = await hospitalService.createDepartment(token, hospitalId, departmentData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['name'], departmentData['name']);
        expect(result['data']['hospital_id'], hospitalId);
      });
    });

    group('getHospitalAlerts', () {
      test('should return hospital alerts and notifications', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        
        final mockResponse = {
          'success': true,
          'data': {
            'alerts': [
              {
                'id': 1,
                'type': 'capacity_warning',
                'title': 'تحذير السعة',
                'message': 'قسم الطوارئ وصل إلى 90% من سعته',
                'priority': 'high',
                'created_at': '2024-01-14T10:30:00Z',
                'is_read': false,
              },
              {
                'id': 2,
                'type': 'doctor_shortage',
                'title': 'نقص في الأطباء',
                'message': 'قسم الباطنة يحتاج إلى طبيب إضافي',
                'priority': 'medium',
                'created_at': '2024-01-14T09:15:00Z',
                'is_read': true,
              },
            ],
            'unread_count': 1,
            'total_alerts': 15,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitalAlerts(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['alerts'], isA<List>());
        expect(result['data']['unread_count'], 1);
      });
    });

    group('searchHospitals', () {
      test('should search hospitals by name', () async {
        // Arrange
        const token = 'valid_token_123';
        const searchQuery = 'الملك';
        
        final mockResponse = {
          'success': true,
          'data': {
            'hospitals': MockData.mockHospitals
                .where((h) => h.name.contains(searchQuery))
                .map((h) => h.toJson())
                .toList(),
            'total_found': 2,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.searchHospitals(token, searchQuery);

        // Assert
        expect(result['success'], true);
        expect(result['data']['hospitals'], isA<List>());
        expect(result['data']['total_found'], greaterThanOrEqualTo(0));
      });

      test('should search hospitals by location', () async {
        // Arrange
        const token = 'valid_token_123';
        const location = 'الرياض';
        
        final mockResponse = {
          'success': true,
          'data': {
            'hospitals': MockData.mockHospitals
                .where((h) => h.address.contains(location))
                .map((h) => h.toJson())
                .toList(),
            'total_found': 1,
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.searchHospitalsByLocation(token, location);

        // Assert
        expect(result['success'], true);
        expect(result['data']['hospitals'], isA<List>());
      });
    });

    group('getHospitalCapacity', () {
      test('should return hospital capacity information', () async {
        // Arrange
        const token = 'valid_token_123';
        const hospitalId = 1;
        
        final mockResponse = {
          'success': true,
          'data': {
            'hospital_id': hospitalId,
            'total_capacity': 200,
            'current_occupancy': 150,
            'occupancy_rate': 0.75,
            'available_beds': 50,
            'department_capacity': [
              {
                'department': 'الطوارئ',
                'total_beds': 20,
                'occupied_beds': 15,
                'available_beds': 5,
                'occupancy_rate': 0.75,
              },
              {
                'department': 'الباطنة',
                'total_beds': 30,
                'occupied_beds': 22,
                'available_beds': 8,
                'occupancy_rate': 0.73,
              },
            ],
          },
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await hospitalService.getHospitalCapacity(token, hospitalId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['total_capacity'], 200);
        expect(result['data']['occupancy_rate'], 0.75);
        expect(result['data']['department_capacity'], isA<List>());
      });
    });

    group('error handling', () {
      test('should handle unauthorized access', () async {
        // Arrange
        const invalidToken = 'invalid_token';
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(MockData.mockUnauthorizedError),
          401,
        ));

        // Act
        final result = await hospitalService.getHospitals(invalidToken);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 401);
      });

      test('should handle server errors', () async {
        // Arrange
        const token = 'valid_token_123';
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(MockData.mockServerError),
          500,
        ));

        // Act
        final result = await hospitalService.getHospitals(token);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 500);
      });

      test('should handle network errors', () async {
        // Arrange
        const token = 'valid_token_123';
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenThrow(Exception('Network error'));

        // Act
        final result = await hospitalService.getHospitals(token);

        // Assert
        expect(result['success'], false);
        expect(result['message'], contains('Network'));
      });
    });
  });
}