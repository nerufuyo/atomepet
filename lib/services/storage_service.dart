import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Logger _logger = Logger();
  SharedPreferences? _prefs;

  static const String _authTokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'email';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _phoneKey = 'phone';
  static const String _isAuthenticatedKey = 'is_authenticated';

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.i('StorageService initialized successfully');
    } catch (e) {
      _logger.e('Error initializing StorageService: $e');
      rethrow;
    }
  }

  // Auth Token
  Future<void> saveAuthToken(String token) async {
    await _prefs?.setString(_authTokenKey, token);
    _logger.d('Auth token saved');
  }

  String? getAuthToken() {
    return _prefs?.getString(_authTokenKey);
  }

  // Username
  Future<void> saveUsername(String username) async {
    await _prefs?.setString(_usernameKey, username);
    _logger.d('Username saved: $username');
  }

  String? getUsername() {
    return _prefs?.getString(_usernameKey);
  }

  // User ID
  Future<void> saveUserId(int userId) async {
    await _prefs?.setInt(_userIdKey, userId);
    _logger.d('User ID saved: $userId');
  }

  int? getUserId() {
    return _prefs?.getInt(_userIdKey);
  }

  // Email
  Future<void> saveEmail(String? email) async {
    if (email != null) {
      await _prefs?.setString(_emailKey, email);
    } else {
      await _prefs?.remove(_emailKey);
    }
  }

  String? getEmail() {
    return _prefs?.getString(_emailKey);
  }

  // First Name
  Future<void> saveFirstName(String? firstName) async {
    if (firstName != null) {
      await _prefs?.setString(_firstNameKey, firstName);
    } else {
      await _prefs?.remove(_firstNameKey);
    }
  }

  String? getFirstName() {
    return _prefs?.getString(_firstNameKey);
  }

  // Last Name
  Future<void> saveLastName(String? lastName) async {
    if (lastName != null) {
      await _prefs?.setString(_lastNameKey, lastName);
    } else {
      await _prefs?.remove(_lastNameKey);
    }
  }

  String? getLastName() {
    return _prefs?.getString(_lastNameKey);
  }

  // Phone
  Future<void> savePhone(String? phone) async {
    if (phone != null) {
      await _prefs?.setString(_phoneKey, phone);
    } else {
      await _prefs?.remove(_phoneKey);
    }
  }

  String? getPhone() {
    return _prefs?.getString(_phoneKey);
  }

  // Authentication status
  Future<void> saveAuthenticationStatus(bool isAuthenticated) async {
    await _prefs?.setBool(_isAuthenticatedKey, isAuthenticated);
    _logger.d('Authentication status saved: $isAuthenticated');
  }

  bool getAuthenticationStatus() {
    return _prefs?.getBool(_isAuthenticatedKey) ?? false;
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await _prefs?.remove(_authTokenKey);
    await _prefs?.remove(_usernameKey);
    await _prefs?.remove(_userIdKey);
    await _prefs?.remove(_emailKey);
    await _prefs?.remove(_firstNameKey);
    await _prefs?.remove(_lastNameKey);
    await _prefs?.remove(_phoneKey);
    await _prefs?.remove(_isAuthenticatedKey);
    _logger.d('All auth data cleared');
  }

  // Clear all storage
  Future<void> clearAll() async {
    await _prefs?.clear();
    _logger.d('All storage cleared');
  }
}
