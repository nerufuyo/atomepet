import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final Logger _logger = Logger();

  static const String petBox = 'pets';
  static const String orderBox = 'orders';
  static const String userBox = 'users';
  static const String cacheBox = 'cache';

  Future<void> init() async {
    try {
      await Hive.initFlutter();

      await Hive.openBox(petBox);
      await Hive.openBox(orderBox);
      await Hive.openBox(userBox);
      await Hive.openBox(cacheBox);

      _logger.i('Database initialized successfully');
    } catch (e) {
      _logger.e('Error initializing database: $e');
      rethrow;
    }
  }

  Box getBox(String boxName) {
    return Hive.box(boxName);
  }

  Future<void> clearAll() async {
    try {
      await Hive.box(petBox).clear();
      await Hive.box(orderBox).clear();
      await Hive.box(userBox).clear();
      await Hive.box(cacheBox).clear();
      _logger.i('All database boxes cleared');
    } catch (e) {
      _logger.e('Error clearing database: $e');
      rethrow;
    }
  }

  Future<void> clearBox(String boxName) async {
    try {
      await Hive.box(boxName).clear();
      _logger.i('Box $boxName cleared');
    } catch (e) {
      _logger.e('Error clearing box $boxName: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    await Hive.close();
  }
}
