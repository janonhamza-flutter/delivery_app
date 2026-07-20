import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/core/services/storage_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      final token = StorageService.getToken();
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }
}
