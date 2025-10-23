import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // UserController is already provided by InitialBinding as a singleton
    // No need to create a new instance here
  }
}
