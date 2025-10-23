import 'package:logger/logger.dart';
import 'package:atomepet/services/user_service.dart';
import 'package:atomepet/models/user.dart';

class UserRepository {
  final UserService _userService;
  final Logger _logger = Logger();

  UserRepository(this._userService);

  Future<User> createUser(User user) async {
    try {
      final newUser = await _userService.createUser(user);
      return newUser;
    } catch (e) {
      _logger.e('Error creating user: $e');
      rethrow;
    }
  }

  Future<void> createUsersWithListInput(List<User> users) async {
    try {
      await _userService.createUsersWithListInput(users);
    } catch (e) {
      _logger.e('Error creating users: $e');
      rethrow;
    }
  }

  Future<String> loginUser(String username, String password) async {
    try {
      final token = await _userService.loginUser(username, password);
      _logger.i('User logged in successfully: $username');
      return token;
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
      await _userService.logoutUser();
    } catch (e) {
      _logger.e('Error logging out: $e');
      rethrow;
    }
  }

  Future<User> getUserByName(String username) async {
    try {
      final user = await _userService.getUserByName(username);
      return user;
    } catch (e) {
      _logger.e('Error getting user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(String username, User user) async {
    try {
      await _userService.updateUser(username, user);
    } catch (e) {
      _logger.e('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String username) async {
    try {
      await _userService.deleteUser(username);
    } catch (e) {
      _logger.e('Error deleting user: $e');
      rethrow;
    }
  }
}
