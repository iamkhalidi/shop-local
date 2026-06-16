import 'package:get/get.dart';
import 'package:shop_local/features/home/binding/home_binding.dart';
import 'package:shop_local/features/home/view/home_screen.dart';
import 'package:shop_local/features/splash/binding/splash_binding.dart';
import 'package:shop_local/features/splash/view/splash_screen.dart';
import 'package:shop_local/features/auth/view/login_screen.dart';
import 'package:shop_local/features/auth/view/register_screen.dart';
import 'package:shop_local/features/auth/view/forgot_password_screen.dart';

import '../features/profile/binding/profile_binding.dart';
import '../features/profile/view/profile_screen.dart';

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
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
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
  ];
}