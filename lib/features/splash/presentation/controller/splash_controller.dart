import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/core/services/storage_service.dart';
import 'package:delivery_app/features/profile/data/repositories/profile_repository.dart';
import 'package:get/get.dart';

// Note: `DioService` is registered in `InitialBinding`, so we can create
// a `ProfileRepository` using `Get.find()` to prefetch profile data.

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();

    // Start both the fixed splash duration and app initialization in parallel.
    final loadingDelay = Future.delayed(const Duration(seconds: 7));

    final initFuture = _initializeApp();

    // Wait until both the delay and initialization complete.
    await Future.wait([loadingDelay, initFuture]);

    final token = StorageService.getToken();
    if (token != null && token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> _initializeApp() async {
    final token = StorageService.getToken();
    if (token == null || token.isEmpty) return;

    try {
      final repo = ProfileRepository(Get.find());
      await repo.getProfile(); // prefetch profile; ignore response for now
    } catch (e) {
      // Ignore profile fetch errors during splash — app can handle later.
    }
  }
}
