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
      
      // If user is not authenticated, redirect to login
      if (!userController.isAuthenticated.value) {
        return const RouteSettings(name: AppRoutes.login);
      }
      
      return null;
    } catch (e) {
      // If UserController is not found, redirect to login
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}