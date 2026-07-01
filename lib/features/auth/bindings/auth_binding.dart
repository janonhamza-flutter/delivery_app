import 'package:delivery_app/core/services/dio_service.dart';
import 'package:get/get.dart';

import '../data/repositories/auth_repository.dart';
import '../presentation/controller/login_controller.dart';
import '../presentation/controller/otp_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioService>(() => DioService());

    Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find<DioService>()));

    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
    );
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
