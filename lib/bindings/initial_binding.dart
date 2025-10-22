import 'package:get/get.dart';
import 'package:atomepet/services/api_service.dart';
import 'package:atomepet/services/database_service.dart';
import 'package:atomepet/services/pet_service.dart';
import 'package:atomepet/services/store_service.dart';
import 'package:atomepet/services/user_service.dart';
import 'package:atomepet/repositories/pet_repository.dart';
import 'package:atomepet/repositories/store_repository.dart';
import 'package:atomepet/repositories/user_repository.dart';
import 'package:atomepet/controllers/theme_controller.dart';
import 'package:atomepet/controllers/user_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService(), fenix: true);
    Get.lazyPut(() => DatabaseService(), fenix: true);

    Get.lazyPut(() => PetService(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => StoreService(Get.find<ApiService>()), fenix: true);
    Get.lazyPut(() => UserService(Get.find<ApiService>()), fenix: true);

    Get.lazyPut(
      () => PetRepository(Get.find<PetService>(), Get.find<DatabaseService>()),
      fenix: true,
    );
    Get.lazyPut(
      () => StoreRepository(
        Get.find<StoreService>(),
        Get.find<DatabaseService>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () =>
          UserRepository(Get.find<UserService>(), Get.find<DatabaseService>()),
      fenix: true,
    );

    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(
      () => UserController(Get.find<UserRepository>()),
      fenix: true,
    );
  }
}
