import 'package:logger/logger.dart';
import 'package:atomepet/services/store_service.dart';
import 'package:atomepet/models/order.dart';

class StoreRepository {
  final StoreService _storeService;
  final Logger _logger = Logger();

  StoreRepository(this._storeService);

  Future<Map<String, int>> getInventory() async {
    try {
      final inventory = await _storeService.getInventory();
      return inventory;
    } catch (e) {
      _logger.e('Error getting inventory: $e');
      rethrow;
    }
  }

  Future<Order> placeOrder(Order order) async {
    try {
      final newOrder = await _storeService.placeOrder(order);
      return newOrder;
    } catch (e) {
      _logger.e('Error placing order: $e');
      rethrow;
    }
  }

  Future<Order> getOrderById(int orderId) async {
    try {
      final order = await _storeService.getOrderById(orderId);
      return order;
    } catch (e) {
      _logger.e('Error getting order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      await _storeService.deleteOrder(orderId);
    } catch (e) {
      _logger.e('Error deleting order: $e');
      rethrow;
    }
  }
}
