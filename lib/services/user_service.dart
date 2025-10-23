import 'package:dio/dio.dart';
import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/models/user.dart';

class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  Future<User> createUser(User user) async {
    try {
      final response = await _apiService.post('/user', data: user.toJson());
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUsersWithListInput(List<User> users) async {
    try {
      await _apiService.post(
        '/user/createWithList',
        data: users.map((user) => user.toJson()).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> loginUser(String username, String password) async {
    try {
      final response = await _apiService.dio.get(
        '/user/login',
        queryParameters: {'username': username, 'password': password},
        options: Options(
          responseType: ResponseType.plain, // Accept plain text response
          headers: {
            'Accept': '*/*',
          },
        ),
      );
      // The API returns a session token or message as plain text
      return response.data?.toString() ?? 'logged in user session';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    try {
      await _apiService.get('/user/logout');
    } catch (e) {
      rethrow;
    }
  }

  Future<User> getUserByName(String username) async {
    try {
      final response = await _apiService.get('/user/$username');
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(String username, User user) async {
    try {
      await _apiService.put('/user/$username', data: user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String username) async {
    try {
      await _apiService.delete('/user/$username');
    } catch (e) {
      rethrow;
    }
  }
}
