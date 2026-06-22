import 'package:get/get.dart';
import 'package:shop_local/features/home/binding/home_binding.dart';
import 'package:shop_local/features/home/view/home_screen.dart';
import 'package:shop_local/features/splash/binding/splash_binding.dart';
import 'package:shop_local/features/splash/view/splash_screen.dart';
import 'package:shop_local/features/auth/view/login_screen.dart';
import 'package:shop_local/features/auth/view/register_screen.dart';
import 'package:shop_local/features/auth/view/forgot_password_screen.dart';

import 'package:shop_local/features/auth/binding/auth_binding.dart'; // 🌟 تم تعديل المسار هنا
import 'package:shop_local/features/dashboard/binding/dashboard_binding.dart'; // 🌟 تم تعديل المسار هنا
import 'package:shop_local/features/dashboard/view/dashboard_screen.dart'; // 🌟 تم تعديل المسار هنا
import 'package:shop_local/features/profile/binding/profile_binding.dart'; // 🌟 تم تعديل المسار هنا
import 'package:shop_local/features/profile/view/profile_screen.dart';

import '../features/categories/view/product_info_screen.dart';
import '../features/favorites/binding/favorites_binding.dart';
import '../features/favorites/view/favorites_screen.dart'; // 🌟 تم تعديل المسار هنا

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
        binding: AuthBinding()
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterScreen(),
        binding: AuthBinding()
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding()

    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITES,
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_INFO,
      page: () => const ProductInfoScreen(),
      // binding: DashboardBinding(),
    ),
  ];
}