import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/models/order.dart';

class StoreService {
  final ApiService _apiService;

  StoreService(this._apiService);

  Future<Map<String, int>> getInventory() async {
    try {
      final response = await _apiService.get('/store/inventory');
      return Map<String, int>.from(response.data);
    } catch (e) {
      rethrow;
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
