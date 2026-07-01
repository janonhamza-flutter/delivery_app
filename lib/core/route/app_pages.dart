import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/features/auth/presentation/pages/login_page.dart';
import 'package:get/get.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),

    // سنضيف Login لاحقًا
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
  ];
}
