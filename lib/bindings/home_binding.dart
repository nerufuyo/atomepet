import 'package:get/get.dart';
import 'package:atomepet/controllers/pet_controller.dart';
import 'package:atomepet/controllers/store_controller.dart';
import 'package:atomepet/repositories/pet_repository.dart';
import 'package:atomepet/repositories/store_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetController(Get.find<PetRepository>()));
    Get.lazyPut(() => StoreController(Get.find<StoreRepository>()));
    // UserController is already provided by InitialBinding as a singleton
  }
}
