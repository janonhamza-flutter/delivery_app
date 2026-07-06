import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/features/auth/presentation/pages/login_page.dart';
import 'package:delivery_app/features/home/presentation/pages/home_page.dart';
import 'package:get/get.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/home/bindings/home_binding.dart';
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
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpPage(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
