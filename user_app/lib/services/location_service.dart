import 'api_service.dart';

class LocationService {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> getNearbyShops({
    required double latitude,
    required double longitude,
    double? maxDistance,
  }) async {
    try {
      final response = await _apiService.post('/location/shops/nearby', {
        'latitude': latitude,
        'longitude': longitude,
        'maxDistance': maxDistance ?? 10,
      });

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch nearby shops: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDeliverableShops({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiService.post('/location/shops/deliverable', {
        'latitude': latitude,
        'longitude': longitude,
      });

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch deliverable shops: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getShopsWithinRadius({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      final response = await _apiService.get(
        '/location/shops/radius?latitude=$latitude&longitude=$longitude&radius=$radius',
      );

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data'] ?? []);
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch shops: $e');
    }
  }
}
