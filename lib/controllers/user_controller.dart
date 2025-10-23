import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:atomepet/models/user.dart';
import 'package:atomepet/repositories/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _userRepository;
  final Logger _logger = Logger();

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
      // Check if there's a stored user or auth token
      if (currentUser.value != null || authToken.value.isNotEmpty) {
        isAuthenticated.value = true;
      } else {
        isAuthenticated.value = false;
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
      
      // Try to fetch user details, but don't fail login if it errors
      try {
        final user = await _userRepository.getUserByName(username);
        currentUser.value = user;
      } catch (e) {
        _logger.w('Failed to fetch user details, but login succeeded: $e');
        // Create a minimal user object with just the username
        currentUser.value = User(
          id: 0,
          username: username,
          email: null,
          firstName: null,
          lastName: null,
          password: null,
          phone: null,
          userStatus: null,
        );
      }
      
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
      final newUser = await _userRepository.createUser(user);
      
      // Registration succeeded, set as current user for convenience
      currentUser.value = newUser;
      isAuthenticated.value = true;
      
      Get.snackbar(
        'success'.tr,
        'Registration successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      _logger.w('Registration failed (API may be unreliable): $e');
      Get.snackbar(
        'error'.tr,
        'Registration may have failed. Try logging in instead.',
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
        try {
          await _userRepository.updateUser(currentUser.value!.username!, user);
        } catch (e) {
          _logger.w('Update API failed, but applying locally: $e');
        }
        // Update locally regardless of API success
        currentUser.value = user;
        Get.snackbar(
          'success'.tr,
          'Profile updated',
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

  void clearError() {
    error.value = '';
  }
}
