import 'package:get/get.dart';
import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/services/pet_service.dart';
import 'package:atomepet/services/store_service.dart';
import 'package:atomepet/services/user_service.dart';
import 'package:atomepet/repositories/pet_repository.dart';
import 'package:atomepet/repositories/store_repository.dart';
import 'package:atomepet/repositories/user_repository.dart';
import 'package:atomepet/controllers/theme_controller.dart';
import 'package:atomepet/controllers/user_controller.dart';
import 'package:atomepet/controllers/cart_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService(), fenix: true);

    Get.lazyPut(() => PetService(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => StoreService(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => UserService(Get.find<ApiService>()), fenix: true);

    Get.lazyPut(
      () => PetRepository(Get.find<PetService>()),
      fenix: true,
    );
    Get.lazyPut(
      () => StoreRepository(Get.find<StoreService>()),
      fenix: true,
    );
    Get.lazyPut(
      () => UserRepository(Get.find<UserService>()),
      fenix: true,
    );

    Get.lazyPut(() => ThemeController(), fenix: true);
    
    // Use Get.put for UserController to create permanent singleton
    // This prevents it from being deleted and recreated during navigation
    Get.put(
      UserController(Get.find<UserRepository>()),
      permanent: true,
    );

    // Cart controller for mobile shopping
    Get.put(
      CartController(Get.find<StoreRepository>()),
      permanent: true,
    );
  }
}
