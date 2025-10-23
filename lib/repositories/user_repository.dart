import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:atomepet/services/user_service.dart';
import 'package:atomepet/services/database_service.dart';
import 'package:atomepet/models/user.dart';

class UserRepository {
  final UserService _userService;
  final DatabaseService _databaseService;
  final Logger _logger = Logger();

  UserRepository(this._userService, this._databaseService);

  Box get _userBox => _databaseService.getBox(DatabaseService.userBox);
  Box get _cacheBox => _databaseService.getBox(DatabaseService.cacheBox);

  Future<bool> _isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<User> createUser(User user) async {
    try {
      if (await _isOnline()) {
        final newUser = await _userService.createUser(user);
        await _userBox.put('user_${newUser.id}', newUser.toJson());
        return newUser;
      } else {
        throw Exception('No internet connection');
      }
    } catch (e) {
      _logger.e('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> createUsersWithListInput(List<User> users) async {
    try {
      if (await _isOnline()) {
        await _userService.createUsersWithListInput(users);
        for (var user in users) {
          await _userBox.put('user_${user.id}', user.toJson());
        }
      } else {
        throw Exception('No internet connection');
      }
    } catch (e) {
      _logger.e('Error creating users: $e');
      rethrow;
    }
  }

  Future<String> loginUser(String username, String password) async {
    try {
      if (await _isOnline()) {
        final token = await _userService.loginUser(username, password);
        await _cacheBox.put('current_user', username);
        await _cacheBox.put('auth_token', token);
        _logger.i('User logged in successfully: $username');
        return token;
      } else {
        throw Exception('No internet connection');
      }
    } on Exception catch (e) {
      _logger.e('Error logging in: $e');
      rethrow;
    } catch (e) {
      _logger.e('Unexpected error logging in: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logoutUser() async {
    try {
      if (await _isOnline()) {
        await _userService.logoutUser();
      }
      await _cacheBox.delete('current_user');
      await _cacheBox.delete('auth_token');
    } catch (e) {
      _logger.e('Error logging out: $e');
      rethrow;
    }
  }

  Future<User> getUserByName(String username) async {
    try {
      if (await _isOnline()) {
        final user = await _userService.getUserByName(username);
        await _userBox.put('user_$username', user.toJson());
        return user;
      } else {
        final cached = _userBox.get('user_$username');
        if (cached != null) {
          return User.fromJson(Map<String, dynamic>.from(cached));
        }
        throw Exception('User not found in cache');
      }
    } catch (e) {
      _logger.e('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String username, User user) async {
    try {
      if (await _isOnline()) {
        await _userService.updateUser(username, user);
        await _userBox.put('user_$username', user.toJson());
      } else {
        await _userBox.put('pending_update_$username', user.toJson());
        throw Exception('Offline: Changes will sync when online');
      }
    } catch (e) {
      _logger.e('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String username) async {
    try {
      if (await _isOnline()) {
        await _userService.deleteUser(username);
        await _userBox.delete('user_$username');
      } else {
        await _userBox.put('pending_delete_$username', true);
        throw Exception('Offline: Deletion will sync when online');
      }
    } catch (e) {
      _logger.e('Error deleting user: $e');
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final username = _cacheBox.get('current_user');
      if (username != null) {
        try {
          // Try to get fresh data from API
          return await getUserByName(username);
        } catch (e) {
          // If API fails, fall back to cached data
          _logger.w('API failed, falling back to cached user data: $e');
          final cached = _userBox.get('user_$username');
          if (cached != null) {
            return User.fromJson(Map<String, dynamic>.from(cached));
          }
          // If no cache, throw error
          throw e;
        }
      }
      return null;
    } catch (e) {
      _logger.e('Error getting current user: $e');
      return null;
    }
  }

  Future<void> syncPendingChanges() async {
    try {
      if (await _isOnline()) {
        final keys = _userBox.keys.toList();
        for (var key in keys) {
          if (key.toString().startsWith('pending_update_')) {
            final username = key.toString().split('_').last;
            final userData = _userBox.get(key);
            final user = User.fromJson(Map<String, dynamic>.from(userData));
            await updateUser(username, user);
            await _userBox.delete(key);
          } else if (key.toString().startsWith('pending_delete_')) {
            final username = key.toString().split('_').last;
            await deleteUser(username);
            await _userBox.delete(key);
          }
        }
        _logger.i('Pending user changes synced successfully');
      }
    } catch (e) {
      _logger.e('Error syncing pending user changes: $e');
    }
  }
}
