import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/models/order.dart';

class StoreService {
  final ApiService _apiService;
  final Logger _logger = Logger();

  StoreService(this._apiService);

  Future<Map<String, int>> getInventory() async {
    try {
      final response = await _apiService.get(
        '/store/inventory',
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );
      
      if (response.statusCode == 500) {
        _logger.w('Store inventory API returned 500');
        // Return empty inventory instead of crashing
        return {};
      }
      
      if (response.data is Map) {
        return Map<String, int>.from(response.data);
      }
      
      return {};
    } catch (e) {
      _logger.e('Error fetching inventory: $e');
      // Return empty map instead of throwing
      return {};
    }
  }

  Future<Order> placeOrder(Order order) async {
    try {
      final response = await _apiService.post(
        '/store/order',
        data: order.toJson(),
      );
      return Order.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Order> getOrderById(int orderId) async {
    try {
      final response = await _apiService.get('/store/order/$orderId');
      return Order.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      await _apiService.delete('/store/order/$orderId');
    } catch (e) {
      rethrow;
    }
  }
}
