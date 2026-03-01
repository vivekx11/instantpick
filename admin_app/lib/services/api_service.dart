import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class ApiService {
  // ⚠️ NO AUTHENTICATION - Open access for development
  
  Future<Map<String, dynamic>> getStats(String adminKey) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminStats}'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getUsers(String adminKey) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminUsers}'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getShops(String adminKey) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminShops}'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getProducts(String adminKey) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminProducts}'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getOrders(String adminKey) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminOrders}'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getLogs(String adminKey) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminLogs}'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> toggleUserStatus(String adminKey, String userId) async {
    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminUsers}/$userId/toggle-status'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteUser(String adminKey, String userId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminUsers}/$userId'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> toggleShopStatus(String adminKey, String shopId) async {
    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminShops}/$shopId/toggle-status'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteShop(String adminKey, String shopId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminShops}/$shopId'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteProduct(String adminKey, String productId) async {
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminProducts}/$productId'),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateOrderStatus(String adminKey, String orderId, String status) async {
    final response = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminOrders}/$orderId/status'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': status}),
    );
    return json.decode(response.body);
  }
}
