import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:atomepet/models/user.dart';
import 'package:atomepet/repositories/user_repository.dart';
import 'package:atomepet/services/storage_service.dart';

class UserController extends GetxController {
  final UserRepository _userRepository;
  final Logger _logger = Logger();
  final StorageService _storageService = StorageService();

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
      // Check if there's stored auth data
      final storedToken = _storageService.getAuthToken();
      final storedUsername = _storageService.getUsername();
      final isAuthStored = _storageService.getAuthenticationStatus();

      if (isAuthStored && storedToken != null && storedUsername != null) {
        // Restore auth state from storage
        authToken.value = storedToken;

        // Try to fetch fresh user data from API
        try {
          final user = await _userRepository.getUserByName(storedUsername);
          currentUser.value = user;
        } catch (e) {
          _logger.w(
            'Failed to fetch user details from API, using stored data: $e',
          );
          // Restore user data from storage
          currentUser.value = User(
            id: _storageService.getUserId() ?? 0,
            username: storedUsername,
            email: _storageService.getEmail(),
            firstName: _storageService.getFirstName(),
            lastName: _storageService.getLastName(),
            phone: _storageService.getPhone(),
            password: null,
            userStatus: 1,
          );
        }

        isAuthenticated.value = true;
        _logger.i('User authenticated from storage: $storedUsername');
      } else {
        isAuthenticated.value = false;
        _logger.i('No stored authentication found');
      }
    } catch (e) {
      _logger.e('Error checking auth status: $e');
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

        // Save full user data to storage
        await _storageService.saveUserId(user.id ?? 0);
        await _storageService.saveEmail(user.email);
        await _storageService.saveFirstName(user.firstName);
        await _storageService.saveLastName(user.lastName);
        await _storageService.savePhone(user.phone);
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
        await _storageService.saveUserId(0);
      }

      // Save auth data to storage
      await _storageService.saveAuthToken(token);
      await _storageService.saveUsername(username);
      await _storageService.saveAuthenticationStatus(true);

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

      // Clear storage
      await _storageService.clearAuthData();

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

        // Update storage
        await _storageService.saveUserId(user.id ?? 0);
        await _storageService.saveEmail(user.email);
        await _storageService.saveFirstName(user.firstName);
        await _storageService.saveLastName(user.lastName);
        await _storageService.savePhone(user.phone);

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

  Future<void> fetchCurrentUserData() async {
    if (currentUser.value?.username == null) {
      _logger.w('Cannot fetch user data: no username available');
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final user = await _userRepository.getUserByName(
        currentUser.value!.username!,
      );
      currentUser.value = user;

      // Update storage with fresh data
      await _storageService.saveUserId(user.id ?? 0);
      await _storageService.saveEmail(user.email);
      await _storageService.saveFirstName(user.firstName);
      await _storageService.saveLastName(user.lastName);
      await _storageService.savePhone(user.phone);

      _logger.i('User data refreshed successfully');
    } catch (e) {
      error.value = e.toString();
      _logger.e('Failed to fetch user data: $e');
      // Don't show error snackbar here, let the UI handle it
    } finally {
      isLoading.value = false;
    }
  }
}
