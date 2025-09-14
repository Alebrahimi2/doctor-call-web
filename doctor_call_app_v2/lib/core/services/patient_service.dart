import 'dart:convert';
import '../models/patient_model.dart';
import './api_service.dart';

class PatientService {
  final ApiService _apiService = ApiService();

  Future<List<Patient>> getAllPatients({
    int? hospitalId,
    String? status,
    String? priority,
    String? severity,
  }) async {
    try {
      final response = await _apiService.getPatients(
        hospitalId: hospitalId,
        status: status,
        priority: priority,
        severity: severity,
      );

      if (response['success'] == true) {
        final List<dynamic> patientsJson = response['patients'] ?? [];
        return patientsJson.map((json) => Patient.fromJson(json)).toList();
      } else {
        throw Exception(response['error'] ?? 'Failed to load patients');
      }
    } catch (e) {
      throw Exception('Error loading patients: $e');
    }
  }

  Future<Patient> getPatientById(int id) async {
    try {
      final response = await _apiService.getPatientById(id);

      if (response['success'] == true) {
        return Patient.fromJson(response['patient']);
      } else {
        throw Exception(response['error'] ?? 'Failed to load patient');
      }
    } catch (e) {
      throw Exception('Error loading patient: $e');
    }
  }

  Future<Patient> createPatient(Map<String, dynamic> patientData) async {
    try {
      final response = await _apiService.createPatient(patientData);

      if (response['success'] == true) {
        return Patient.fromJson(response['patient']);
      } else {
        throw Exception(response['error'] ?? 'Failed to create patient');
      }
    } catch (e) {
      throw Exception('Error creating patient: $e');
    }
  }

  Future<Patient> updatePatient(
    int id,
    Map<String, dynamic> patientData,
  ) async {
    try {
      final response = await _apiService.updatePatient(id, patientData);

      if (response['success'] == true) {
        return Patient.fromJson(response['patient']);
      } else {
        throw Exception(response['error'] ?? 'Failed to update patient');
      }
    } catch (e) {
      throw Exception('Error updating patient: $e');
    }
  }

  Future<void> deletePatient(int id) async {
    try {
      final response = await _apiService.deletePatient(id);

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Failed to delete patient');
      }
    } catch (e) {
      throw Exception('Error deleting patient: $e');
    }
  }
}
