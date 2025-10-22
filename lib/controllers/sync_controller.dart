import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/controllers/store_controller.dart';
import 'package:atomepet/controllers/user_controller.dart';

class SyncController extends GetxController {
  final PetController _petController;
  final StoreController _storeController;
  final UserController _userController;

  SyncController(
    this._petController,
    this._storeController,
    this._userController,
  );

  final RxBool isSyncing = false.obs;
  final RxBool isOnline = true.obs;
  final RxString lastSyncTime = ''.obs;
  final RxInt pendingChanges = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityListener();
    checkConnectivity();
    updatePendingChangesCount();
  }

  Future<void> updatePendingChangesCount() async {
    // This is a placeholder - in a real app, you'd query the database
    // for the count of pending changes across all entities
    pendingChanges.value = 0;
  }

  void _initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((result) {
      _handleConnectivityChange(result);
    });
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    final wasOffline = !isOnline.value;
    isOnline.value = result != ConnectivityResult.none;

    if (wasOffline && isOnline.value) {
      Get.snackbar(
        'success'.tr,
        'Back online',
        snackPosition: SnackPosition.BOTTOM,
      );
      syncAll();
    } else if (!isOnline.value) {
      Get.snackbar(
        'offline_mode'.tr,
        'Working offline',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    isOnline.value = result != ConnectivityResult.none;
  }

  Future<void> syncAll() async {
    if (!isOnline.value) {
      Get.snackbar(
        'error'.tr,
        'No internet connection',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSyncing.value = true;

      await Future.wait([
        _petController.syncPendingChanges(),
        _storeController.syncPendingOrders(),
        _userController.syncPendingChanges(),
      ]);

      lastSyncTime.value = DateTime.now().toIso8601String();
      await updatePendingChangesCount();

      Get.snackbar(
        'success'.tr,
        'All data synced successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Sync failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> syncPets() async {
    if (!isOnline.value) return;

    try {
      isSyncing.value = true;
      await _petController.syncPendingChanges();
      Get.snackbar(
        'success'.tr,
        'Pets synced successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to sync pets',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> syncOrders() async {
    if (!isOnline.value) return;

    try {
      isSyncing.value = true;
      await _storeController.syncPendingOrders();
      Get.snackbar(
        'success'.tr,
        'Orders synced successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to sync orders',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> syncProfile() async {
    if (!isOnline.value) return;

    try {
      isSyncing.value = true;
      await _userController.syncPendingChanges();
      Get.snackbar(
        'success'.tr,
        'Profile synced successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to sync profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSyncing.value = false;
    }
  }

  String getLastSyncTimeFormatted() {
    if (lastSyncTime.value.isEmpty) {
      return 'Never synced';
    }
    final dateTime = DateTime.parse(lastSyncTime.value);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
