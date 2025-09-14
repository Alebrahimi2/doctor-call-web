import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hospital_model.dart';
import '../constants/api_constants.dart';

class HospitalService {
  static const String baseUrl = ApiConstants.baseUrl;

  Future<List<Hospital>> getAllHospitals(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hospitalsJson = data['data'] ?? [];
        return hospitalsJson.map((json) => Hospital.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hospitals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading hospitals: $e');
    }
  }

  Future<Hospital> getHospitalById(int id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/$id'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Hospital.fromJson(data['data']);
      } else {
        throw Exception('Failed to load hospital: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading hospital: $e');
    }
  }

  Future<Hospital> createHospital(
    Map<String, dynamic> hospitalData,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hospitals'),
        headers: ApiConstants.getAuthHeaders(token),
        body: json.encode(hospitalData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Hospital.fromJson(data['data']);
      } else {
        throw Exception('Failed to create hospital: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating hospital: $e');
    }
  }

  Future<Hospital> updateHospital(
    int id,
    Map<String, dynamic> hospitalData,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/hospitals/$id'),
        headers: ApiConstants.getAuthHeaders(token),
        body: json.encode(hospitalData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Hospital.fromJson(data['data']);
      } else {
        throw Exception('Failed to update hospital: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating hospital: $e');
    }
  }

  Future<void> deleteHospital(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/hospitals/$id'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete hospital: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting hospital: $e');
    }
  }

  Future<List<Hospital>> getNearbyHospitals(
    double latitude,
    double longitude,
    double radius,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/hospitals/nearby?lat=$latitude&lng=$longitude&radius=$radius',
        ),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hospitalsJson = data['data'] ?? [];
        return hospitalsJson.map((json) => Hospital.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load nearby hospitals: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading nearby hospitals: $e');
    }
  }

  Future<Map<String, dynamic>> getHospitalStats(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/stats'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load hospital stats: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading hospital stats: $e');
    }
  }

  Future<Map<String, dynamic>> getHospitalDetailsWithStats(
    int id,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/$id/stats'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load hospital details: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading hospital details: $e');
    }
  }

  Future<List<Hospital>> getHospitalsBySpecialization(
    String specialization,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/hospitals/specialization/${Uri.encodeComponent(specialization)}',
        ),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hospitalsJson = data['data'] ?? [];
        return hospitalsJson.map((json) => Hospital.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load hospitals by specialization: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading hospitals by specialization: $e');
    }
  }

  Future<List<Hospital>> getHospitalsWithAvailableBeds(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/available-beds'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hospitalsJson = data['data'] ?? [];
        return hospitalsJson.map((json) => Hospital.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load hospitals with available beds: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading hospitals with available beds: $e');
    }
  }

  Future<List<Hospital>> searchHospitals(String query, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/search?q=${Uri.encodeComponent(query)}'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hospitalsJson = data['data'] ?? [];
        return hospitalsJson.map((json) => Hospital.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search hospitals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching hospitals: $e');
    }
  }

  Future<Map<String, dynamic>> updateHospitalStatus(
    int id,
    String status,
    String token,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/hospitals/$id/status'),
        headers: ApiConstants.getAuthHeaders(token),
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to update hospital status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating hospital status: $e');
    }
  }

  Future<Map<String, dynamic>> updateBedCount(
    int id,
    int availableBeds,
    String token,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/hospitals/$id/beds'),
        headers: ApiConstants.getAuthHeaders(token),
        body: json.encode({'available_beds': availableBeds}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update bed count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating bed count: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHospitalDepartments(
    int hospitalId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/$hospitalId/departments'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception(
          'Failed to load hospital departments: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading hospital departments: $e');
    }
  }

  Future<Map<String, dynamic>> getHospitalPerformanceMetrics(
    int id,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/$id/performance'),
        headers: ApiConstants.getAuthHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load hospital performance: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading hospital performance: $e');
    }
  }
}
