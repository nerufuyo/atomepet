import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atomepet/controllers/user_controller.dart';
import 'package:atomepet/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    try {
      final userController = Get.find<UserController>();
      
      print('AuthMiddleware - Route: $route');
      print('AuthMiddleware - isAuthenticated: ${userController.isAuthenticated.value}');
      
      // If user is not authenticated, redirect to login
      if (!userController.isAuthenticated.value) {
        print('AuthMiddleware - Redirecting to login from $route');
        return const RouteSettings(name: AppRoutes.login);
      }
      
      print('AuthMiddleware - Access granted to $route');
      return null;
    } catch (e) {
      // If UserController is not found, redirect to login
      print('AuthMiddleware - Error: $e, redirecting to login');
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}