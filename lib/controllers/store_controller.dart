import 'package:get/get.dart';
import 'package:atomepet/models/order.dart';
import 'package:atomepet/repositories/store_repository.dart';

class StoreController extends GetxController {
  final StoreRepository _storeRepository;

  StoreController(this._storeRepository);

  final RxMap<String, int> inventory = <String, int>{}.obs;
  final RxList<Order> orders = <Order>[].obs;
  final Rx<Order?> selectedOrder = Rx<Order?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInventory();
    fetchCachedOrders();
  }

  Future<void> fetchInventory() async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _storeRepository.getInventory();
      inventory.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder(Order order) async {
    try {
      isLoading.value = true;
      error.value = '';
      final newOrder = await _storeRepository.placeOrder(order);
      orders.add(newOrder);
      Get.snackbar(
        'success'.tr,
        'Order placed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderById(int orderId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final result = await _storeRepository.getOrderById(orderId);
      selectedOrder.value = result;
      final index = orders.indexWhere((o) => o.id == orderId);
      if (index == -1) {
        orders.add(result);
      } else {
        orders[index] = result;
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _storeRepository.deleteOrder(orderId);
      orders.removeWhere((o) => o.id == orderId);
      if (selectedOrder.value?.id == orderId) {
        selectedOrder.value = null;
      }
      Get.snackbar(
        'success'.tr,
        'Order deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCachedOrders() async {
    try {
      final cached = await _storeRepository.getCachedOrders();
      orders.value = cached;
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> syncPendingOrders() async {
    try {
      isLoading.value = true;
      await _storeRepository.syncPendingOrders();
      await fetchCachedOrders();
      Get.snackbar(
        'success'.tr,
        'Orders synced successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void selectOrder(Order order) {
    selectedOrder.value = order;
  }

  void clearSelectedOrder() {
    selectedOrder.value = null;
  }

  List<Order> getOrdersByStatus(OrderStatus status) {
    return orders.where((order) => order.status == status).toList();
  }

  void clearError() {
    error.value = '';
  }
}
