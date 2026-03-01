import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AdminProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isAuthenticated = false;
  String? _adminKey;
  
  Map<String, dynamic>? _stats;
  List<dynamic> _users = [];
  List<dynamic> _shops = [];
  List<dynamic> _products = [];
  List<dynamic> _orders = [];
  Map<String, dynamic>? _logs;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get stats => _stats;
  List<dynamic> get users => _users;
  List<dynamic> get shops => _shops;
  List<dynamic> get products => _products;
  List<dynamic> get orders => _orders;
  Map<String, dynamic>? get logs => _logs;

  AdminProvider() {
    _loadAdminKey();
  }

  Future<void> _loadAdminKey() async {
    final prefs = await SharedPreferences.getInstance();
    _adminKey = prefs.getString('admin_key');
    _isAuthenticated = _adminKey != null;
    notifyListeners();
    
    if (_isAuthenticated) {
      await loadDashboardData();
    }
  }

  Future<bool> login(String adminKey) async {
    try {
      final response = await _apiService.getStats(adminKey);
      if (response['success']) {
        _adminKey = adminKey;
        _isAuthenticated = true;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_key', adminKey);
        
        notifyListeners();
        await loadDashboardData();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin_key');
    _adminKey = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    // No auth required - direct API call
    try {
      final response = await _apiService.getStats(''); // Empty key, not used
      if (response['success']) {
        _stats = response['stats'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
      // Set empty stats to show UI even on error
      _stats = {
        'totalUsers': 0,
        'totalShops': 0,
        'totalProducts': 0,
        'totalOrders': 0,
        'activeShops': 0,
        'pendingOrders': 0,
      };
      notifyListeners();
    }
  }

  Future<void> loadUsers() async {
    // No auth required
    try {
      final response = await _apiService.getUsers('');
      if (response['success']) {
        _users = response['users'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
    }
  }

  Future<void> loadShops() async {
    // No auth required
    try {
      final response = await _apiService.getShops('');
      if (response['success']) {
        _shops = response['shops'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading shops: $e');
    }
  }

  Future<void> loadProducts() async {
    // No auth required
    try {
      final response = await _apiService.getProducts('');
      if (response['success']) {
        _products = response['products'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  Future<void> loadOrders() async {
    // No auth required
    try {
      final response = await _apiService.getOrders('');
      if (response['success']) {
        _orders = response['orders'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
    }
  }

  Future<void> loadLogs() async {
    // No auth required
    try {
      final response = await _apiService.getLogs('');
      if (response['success']) {
        _logs = response['logs'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading logs: $e');
    }
  }

  Future<bool> toggleUserStatus(String userId) async {
    // No auth required
    try {
      final response = await _apiService.toggleUserStatus('', userId);
      if (response['success']) {
        await loadUsers();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    // No auth required
    try {
      final response = await _apiService.deleteUser('', userId);
      if (response['success']) {
        await loadUsers();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleShopStatus(String shopId) async {
    // No auth required
    try {
      final response = await _apiService.toggleShopStatus('', shopId);
      if (response['success']) {
        await loadShops();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteShop(String shopId) async {
    // No auth required
    try {
      final response = await _apiService.deleteShop('', shopId);
      if (response['success']) {
        await loadShops();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    // No auth required
    try {
      final response = await _apiService.deleteProduct('', productId);
      if (response['success']) {
        await loadProducts();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    // No auth required
    try {
      final response = await _apiService.updateOrderStatus('', orderId, status);
      if (response['success']) {
        await loadOrders();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
