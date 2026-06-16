part of 'app_pages.dart';


abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const HOME = _Paths.HOME;
  static const PROFILE = _Paths.PROFILE;
  static const DASHBOARD = _Paths.DASHBOARD;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const DASHBOARD = '/dashboard';
}