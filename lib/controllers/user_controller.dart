import 'package:get/get.dart';
import 'package:atomepet/models/user.dart';
import 'package:atomepet/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString error = ''.obs;
  final RxString authToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = await _userRepository.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        isAuthenticated.value = true;
      }
    } catch (e) {
      isAuthenticated.value = false;
    }
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      final token = await _userRepository.loginUser(username, password);
      authToken.value = token;
      final user = await _userRepository.getUserByName(username);
      currentUser.value = user;
      isAuthenticated.value = true;
      Get.snackbar(
        'success'.tr,
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      isAuthenticated.value = false;
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _userRepository.logoutUser();
      currentUser.value = null;
      authToken.value = '';
      isAuthenticated.value = false;
      Get.snackbar(
        'success'.tr,
        'Logged out successfully',
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

  Future<void> register(User user) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _userRepository.createUser(user);
      Get.snackbar(
        'success'.tr,
        'Registration successful. Please login.',
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

  Future<void> updateProfile(User user) async {
    try {
      isLoading.value = true;
      error.value = '';
      if (currentUser.value?.username != null) {
        await _userRepository.updateUser(currentUser.value!.username!, user);
        currentUser.value = user;
        Get.snackbar(
          'success'.tr,
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
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

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      error.value = '';
      if (currentUser.value?.username != null) {
        await _userRepository.deleteUser(currentUser.value!.username!);
        currentUser.value = null;
        authToken.value = '';
        isAuthenticated.value = false;
        Get.snackbar(
          'success'.tr,
          'Account deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
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

  Future<void> syncPendingChanges() async {
    try {
      isLoading.value = true;
      await _userRepository.syncPendingChanges();
      Get.snackbar(
        'success'.tr,
        'Profile synced successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = '';
  }
}
