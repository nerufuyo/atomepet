import 'package:get/get.dart';
import 'package:atomepet/routes/app_routes.dart';
import 'package:atomepet/config/app_transitions.dart';
import 'package:atomepet/views/screens/splash_screen.dart';
import 'package:atomepet/views/screens/auth/login_screen.dart';
import 'package:atomepet/views/screens/auth/register_screen.dart';
import 'package:atomepet/views/screens/home/home_screen.dart';
import 'package:atomepet/views/screens/pet/pet_list_screen.dart';
import 'package:atomepet/views/screens/pet/pet_detail_screen.dart';
import 'package:atomepet/views/screens/store/store_screen.dart';
import 'package:atomepet/views/screens/store/order_history_screen.dart';
import 'package:atomepet/views/screens/profile/profile_screen.dart';
import 'package:atomepet/bindings/home_binding.dart';
import 'package:atomepet/bindings/auth_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: AppTransitions.fastDuration,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.petList,
      page: () => const PetListScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.petDetail,
      page: () => const PetDetailScreen(),
      binding: HomeBinding(),
      transition: Transition.downToUp,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.store,
      page: () => const StoreScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: AppTransitions.defaultDuration,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: AppTransitions.defaultDuration,
    ),
  ];
}
