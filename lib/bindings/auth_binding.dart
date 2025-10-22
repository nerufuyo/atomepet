import 'package:get/get.dart';
import 'package:atomepet/controllers/user_controller.dart';
import 'package:atomepet/repositories/user_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController(Get.find<UserRepository>()));
  }
}
