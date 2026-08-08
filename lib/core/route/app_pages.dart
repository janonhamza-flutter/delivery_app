import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/features/auth/presentation/pages/login_page.dart';
import 'package:delivery_app/features/delivery/bindings/delivery_binding.dart'
    show ActiveDeliveryBinding;
import 'package:delivery_app/features/delivery/presentation/pages/delivery_page.dart';
import 'package:delivery_app/features/history/bindings/history_binding.dart';
import 'package:delivery_app/features/history/presentation/pages/history_page.dart';
import 'package:delivery_app/features/home/presentation/pages/home_page.dart';
import 'package:delivery_app/features/ordrer_details/bindings/order_details_binding.dart'
    show OrderDetailsBinding;
import 'package:delivery_app/features/ordrer_details/presentation/pages/order_details_page.dart'
    show OrderDetailsPage;
import 'package:get/get.dart';

import '../../features/auth/bindings/auth_binding.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/main/bindings/main_binding.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),

    GetPage(name: AppRoutes.otp, page: () => OtpPage(), binding: AuthBinding()),

    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.main,
      page: () => MainPage(),
      binding: MainBinding(),
    ),

    GetPage(
      name: AppRoutes.orderDetails,
      page: () => OrderDetailsPage(),
      binding: OrderDetailsBinding(),
    ),

    GetPage(
      name: AppRoutes.activeDelivery,
      page: () => ActiveDeliveryPage(),
      binding: ActiveDeliveryBinding(),
    ),

    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
    ),

   
  ];
}
