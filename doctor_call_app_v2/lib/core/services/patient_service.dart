import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient_model.dart';
import '../constants/api_constants.dart';

class PatientService {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<List<Patient>> getAllPatients(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> patientsJson = data['data'] ?? [];
        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load patients: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading patients: $e');
    }
  }

  Future<Patient> getPatientById(int id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Patient.fromJson(data['data']);
      } else {
        throw Exception('Failed to load patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading patient: $e');
    }
  }

  Future<Patient> createPatient(
    Map<String, dynamic> patientData,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patients'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(patientData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Patient.fromJson(data['data']);
      } else {
        throw Exception('Failed to create patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating patient: $e');
    }
  }

  Future<Patient> updatePatient(
    int id,
    Map<String, dynamic> patientData,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/patients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(patientData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Patient.fromJson(data['data']);
      } else {
        throw Exception('Failed to update patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating patient: $e');
    }
  }

  Future<void> deletePatient(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/patients/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting patient: $e');
    }
  }

  Future<List<Patient>> getPatientsByStatus(String status, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/status/$status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> patientsJson = data['data'] ?? [];
        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load patients by status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading patients by status: $e');
    }
  }

  Future<List<Patient>> getPatientsByHospital(
    int hospitalId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/hospital/$hospitalId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> patientsJson = data['data'] ?? [];
        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load patients by hospital: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading patients by hospital: $e');
    }
  }

  Future<Map<String, dynamic>> updatePatientStatus(
    int id,
    String status,
    String token,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/patients/$id/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to update patient status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating patient status: $e');
    }
  }

  Future<Map<String, dynamic>> getPatientStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/stats'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load patient stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading patient stats: $e');
    }
  }

  Future<List<Patient>> searchPatients(String query, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/search?q=${Uri.encodeComponent(query)}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> patientsJson = data['data'] ?? [];
        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search patients: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching patients: $e');
    }
  }

  Future<Map<String, dynamic>> assignPatientToHospital(
    int patientId,
    int hospitalId,
    String token,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/patients/$patientId/assign'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'hospital_id': hospitalId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to assign patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error assigning patient: $e');
    }
  }

  Future<Map<String, dynamic>> getPatientHistory(
    int patientId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId/history'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load patient history: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading patient history: $e');
    }
  }
}
