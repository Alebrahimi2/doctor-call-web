import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:doctor_call_app_v2/core/services/patient_service.dart';
import 'package:doctor_call_app_v2/core/models/patient_model.dart';
import '../mocks/mock_data.dart';

// Generate mock classes
@GenerateMocks([http.Client])
import 'patient_service_test.mocks.dart';

void main() {
  group('PatientService Tests', () {
    late PatientService patientService;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient();
      patientService = PatientService();
      // Inject mock client into patient service
    });

    group('getPatients', () {
      test('should return list of patients', () async {
        // Arrange
        const token = 'valid_token_123';
        const page = 1;
        const limit = 10;
        
        final mockResponse = {
          'success': true,
          'data': {
            'patients': MockData.mockPatients.map((p) => p.toJson()).toList(),
            'pagination': {
              'current_page': 1,
              'total_pages': 3,
              'total_count': 25,
              'per_page': 10,
            },
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
        final result = await patientService.getPatients(token, page, limit);

        // Assert
        expect(result['success'], true);
        expect(result['data']['patients'], isA<List>());
        expect(result['data']['patients'].length, MockData.mockPatients.length);
        expect(result['data']['pagination']['current_page'], 1);
      });

      test('should filter patients by status', () async {
        // Arrange
        const token = 'valid_token_123';
        const status = 'waiting';
        
        final mockResponse = {
          'success': true,
          'data': {
            'patients': MockData.mockPatients
                .where((p) => p.status == status)
                .map((p) => p.toJson())
                .toList(),
            'pagination': {
              'current_page': 1,
              'total_pages': 1,
              'total_count': 2,
              'per_page': 10,
            },
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
        final result = await patientService.getPatientsByStatus(token, status);

        // Assert
        expect(result['success'], true);
        expect(result['data']['patients'], isA<List>());
        // All returned patients should have waiting status
        for (var patient in result['data']['patients']) {
          expect(patient['status'], status);
        }
      });

      test('should filter patients by priority', () async {
        // Arrange
        const token = 'valid_token_123';
        const priority = 'urgent';
        
        final mockResponse = {
          'success': true,
          'data': {
            'patients': MockData.mockPatients
                .where((p) => p.priority == priority)
                .map((p) => p.toJson())
                .toList(),
            'pagination': {
              'current_page': 1,
              'total_pages': 1,
              'total_count': 1,
              'per_page': 10,
            },
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
        final result = await patientService.getPatientsByPriority(token, priority);

        // Assert
        expect(result['success'], true);
        expect(result['data']['patients'], isA<List>());
        // All returned patients should have urgent priority
        for (var patient in result['data']['patients']) {
          expect(patient['priority'], priority);
        }
      });
    });

    group('getPatientById', () {
      test('should return patient details', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 1;
        final mockPatient = MockData.mockPatients.first;
        
        final mockResponse = {
          'success': true,
          'data': mockPatient.toJson(),
        };
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await patientService.getPatientById(token, patientId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['id'], patientId);
        expect(result['data']['name'], mockPatient.name);
        expect(result['data']['symptoms'], isA<List>());
      });

      test('should handle patient not found', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 999;
        
        when(mockHttpClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
          json.encode(MockData.mockNotFoundError),
          404,
        ));

        // Act
        final result = await patientService.getPatientById(token, patientId);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 404);
      });
    });

    group('createPatient', () {
      test('should create new patient successfully', () async {
        // Arrange
        const token = 'valid_token_123';
        final patientData = {
          'name': 'مريض جديد',
          'age': 35,
          'gender': 'male',
          'symptoms': ['صداع', 'حمى'],
          'priority': 'normal',
          'hospital_id': 1,
        };
        
        final mockResponse = {
          'success': true,
          'message': 'تم إنشاء ملف المريض بنجاح',
          'data': {
            'id': 4,
            'name': patientData['name'],
            'age': patientData['age'],
            'gender': patientData['gender'],
            'symptoms': patientData['symptoms'],
            'priority': patientData['priority'],
            'status': 'waiting',
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
        final result = await patientService.createPatient(token, patientData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['name'], patientData['name']);
        expect(result['data']['status'], 'waiting');
      });

      test('should validate required fields', () async {
        // Arrange
        const token = 'valid_token_123';
        final invalidPatientData = {
          'age': 35,
          // Missing required fields: name, symptoms
        };
        
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(MockData.mockValidationError),
          422,
        ));

        // Act
        final result = await patientService.createPatient(token, invalidPatientData);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 422);
        expect(result['errors'], isNotNull);
      });
    });

    group('updatePatient', () {
      test('should update patient information', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 1;
        final updateData = {
          'status': 'in_progress',
          'assigned_doctor_id': 1,
          'notes': 'بدء الفحص',
        };
        
        final updatedPatient = MockData.mockPatients.first;
        final mockResponse = {
          'success': true,
          'message': 'تم تحديث بيانات المريض بنجاح',
          'data': {
            ...updatedPatient.toJson(),
            'status': updateData['status'],
            'assigned_doctor_id': updateData['assigned_doctor_id'],
            'notes': updateData['notes'],
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
        final result = await patientService.updatePatient(token, patientId, updateData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['status'], updateData['status']);
        expect(result['data']['assigned_doctor_id'], updateData['assigned_doctor_id']);
      });
    });

    group('assignPatient', () {
      test('should assign patient to doctor', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 1;
        const doctorId = 1;
        
        final mockResponse = {
          'success': true,
          'message': 'تم تعيين المريض للطبيب بنجاح',
          'data': {
            'patient_id': patientId,
            'doctor_id': doctorId,
            'assigned_at': DateTime.now().toIso8601String(),
          },
        };
        
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await patientService.assignPatient(token, patientId, doctorId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['patient_id'], patientId);
        expect(result['data']['doctor_id'], doctorId);
      });

      test('should handle patient already assigned', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 1;
        const doctorId = 1;
        
        final mockResponse = {
          'success': false,
          'message': 'المريض مُعيَّن بالفعل لطبيب آخر',
          'error_code': 409,
        };
        
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          409,
        ));

        // Act
        final result = await patientService.assignPatient(token, patientId, doctorId);

        // Assert
        expect(result['success'], false);
        expect(result['error_code'], 409);
      });
    });

    group('completePatient', () {
      test('should complete patient treatment', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 1;
        final completionData = {
          'diagnosis': 'الحمى الفيروسية',
          'treatment': 'أدوية خافض للحرارة ومسكن',
          'notes': 'المريض في حالة جيدة، ينصح بالراحة',
        };
        
        final mockResponse = {
          'success': true,
          'message': 'تم إنهاء علاج المريض بنجاح',
          'data': {
            'patient_id': patientId,
            'status': 'completed',
            'completed_at': DateTime.now().toIso8601String(),
            'diagnosis': completionData['diagnosis'],
            'treatment': completionData['treatment'],
            'notes': completionData['notes'],
          },
        };
        
        when(mockHttpClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
          json.encode(mockResponse),
          200,
        ));

        // Act
        final result = await patientService.completePatient(token, patientId, completionData);

        // Assert
        expect(result['success'], true);
        expect(result['data']['status'], 'completed');
        expect(result['data']['diagnosis'], completionData['diagnosis']);
      });
    });

    group('getPatientHistory', () {
      test('should return patient medical history', () async {
        // Arrange
        const token = 'valid_token_123';
        const patientId = 1;
        
        final mockResponse = {
          'success': true,
          'data': {
            'patient_id': patientId,
            'visits': [
              {
                'id': 1,
                'date': '2024-01-10T10:00:00Z',
                'diagnosis': 'الحمى الفيروسية',
                'treatment': 'أدوية خافض للحرارة',
                'doctor_name': 'د. أحمد محمد',
                'notes': 'حالة بسيطة',
              },
              {
                'id': 2,
                'date': '2024-01-05T14:30:00Z',
                'diagnosis': 'صداع التوتر',
                'treatment': 'مسكن للألم',
                'doctor_name': 'د. فاطمة علي',
                'notes': 'ينصح بتقليل التوتر',
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
        final result = await patientService.getPatientHistory(token, patientId);

        // Assert
        expect(result['success'], true);
        expect(result['data']['visits'], isA<List>());
        expect(result['data']['visits'].length, 2);
      });
    });

    group('searchPatients', () {
      test('should search patients by name', () async {
        // Arrange
        const token = 'valid_token_123';
        const searchQuery = 'أحمد';
        
        final mockResponse = {
          'success': true,
          'data': {
            'patients': MockData.mockPatients
                .where((p) => p.name.contains(searchQuery))
                .map((p) => p.toJson())
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
        final result = await patientService.searchPatients(token, searchQuery);

        // Assert
        expect(result['success'], true);
        expect(result['data']['patients'], isA<List>());
        expect(result['data']['total_found'], greaterThanOrEqualTo(0));
      });

      test('should return empty results for no matches', () async {
        // Arrange
        const token = 'valid_token_123';
        const searchQuery = 'اسم غير موجود';
        
        final mockResponse = {
          'success': true,
          'data': {
            'patients': [],
            'total_found': 0,
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
        final result = await patientService.searchPatients(token, searchQuery);

        // Assert
        expect(result['success'], true);
        expect(result['data']['patients'], isEmpty);
        expect(result['data']['total_found'], 0);
      });
    });

    group('getPatientStatistics', () {
      test('should return patient statistics', () async {
        // Arrange
        const token = 'valid_token_123';
        
        final mockResponse = {
          'success': true,
          'data': {
            'total_patients': 125,
            'waiting_patients': 8,
            'in_progress_patients': 12,
            'completed_patients': 105,
            'urgent_patients': 3,
            'average_wait_time': 25, // minutes
            'average_treatment_time': 45, // minutes
            'today_stats': {
              'new_patients': 15,
              'completed_treatments': 22,
              'current_waiting': 8,
            },
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
        final result = await patientService.getPatientStatistics(token);

        // Assert
        expect(result['success'], true);
        expect(result['data']['total_patients'], 125);
        expect(result['data']['waiting_patients'], 8);
        expect(result['data']['today_stats'], isNotNull);
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
        final result = await patientService.getPatients(invalidToken, 1, 10);

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
        final result = await patientService.getPatients(token, 1, 10);

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
        final result = await patientService.getPatients(token, 1, 10);

        // Assert
        expect(result['success'], false);
        expect(result['message'], contains('Network'));
      });
    });
  });
}