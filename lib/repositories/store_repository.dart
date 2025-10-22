import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:atomepet/services/store_service.dart';
import 'package:atomepet/services/database_service.dart';
import 'package:atomepet/models/order.dart';

class StoreRepository {
  final StoreService _storeService;
  final DatabaseService _databaseService;
  final Logger _logger = Logger();

  StoreRepository(this._storeService, this._databaseService);

  Box get _orderBox => _databaseService.getBox(DatabaseService.orderBox);
  Box get _cacheBox => _databaseService.getBox(DatabaseService.cacheBox);

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<Map<String, int>> getInventory() async {
    try {
      if (await _isOnline()) {
        final inventory = await _storeService.getInventory();
        await _cacheBox.put('inventory', inventory);
        return inventory;
      } else {
        final cached = _cacheBox.get('inventory');
        if (cached != null) {
          return Map<String, int>.from(cached);
        }
        throw Exception('No cached inventory data');
      }
    } catch (e) {
      _logger.e('Error getting inventory: $e');
      rethrow;
    }
  }

  Future<Order> placeOrder(Order order) async {
    try {
      if (await _isOnline()) {
        final newOrder = await _storeService.placeOrder(order);
        await _orderBox.put('order_${newOrder.id}', newOrder.toJson());
        return newOrder;
      } else {
        await _orderBox.put(
          'pending_order_${DateTime.now().millisecondsSinceEpoch}',
          order.toJson(),
        );
        throw Exception('Offline: Order will be placed when online');
      }
    } catch (e) {
      _logger.e('Error placing order: $e');
      rethrow;
    }
  }

  Future<Order> getOrderById(int orderId) async {
    try {
      if (await _isOnline()) {
        final order = await _storeService.getOrderById(orderId);
        await _orderBox.put('order_$orderId', order.toJson());
        return order;
      } else {
        final cached = _orderBox.get('order_$orderId');
        if (cached != null) {
          return Order.fromJson(Map<String, dynamic>.from(cached));
        }
        throw Exception('Order not found in cache');
      }
    } catch (e) {
      _logger.e('Error getting order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      if (await _isOnline()) {
        await _storeService.deleteOrder(orderId);
        await _orderBox.delete('order_$orderId');
      } else {
        await _orderBox.put('pending_delete_$orderId', true);
        throw Exception('Offline: Deletion will sync when online');
      }
    } catch (e) {
      _logger.e('Error deleting order: $e');
      rethrow;
    }
  }

  Future<List<Order>> getCachedOrders() async {
    try {
      return _orderBox.values
          .where((v) => v is Map && v.containsKey('petId'))
          .map((v) => Order.fromJson(Map<String, dynamic>.from(v)))
          .toList();
    } catch (e) {
      _logger.e('Error getting cached orders: $e');
      return [];
    }
  }

  Future<void> syncPendingOrders() async {
    try {
      if (await _isOnline()) {
        final keys = _orderBox.keys.toList();
        for (var key in keys) {
          if (key.toString().startsWith('pending_order_')) {
            final orderData = _orderBox.get(key);
            final order = Order.fromJson(Map<String, dynamic>.from(orderData));
            await placeOrder(order);
            await _orderBox.delete(key);
          } else if (key.toString().startsWith('pending_delete_')) {
            final orderId = int.parse(key.toString().split('_').last);
            await deleteOrder(orderId);
            await _orderBox.delete(key);
          }
        }
        _logger.i('Pending orders synced successfully');
      }
    } catch (e) {
      _logger.e('Error syncing pending orders: $e');
    }
  }
}
