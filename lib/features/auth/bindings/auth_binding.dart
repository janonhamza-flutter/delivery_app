import 'package:get/get.dart';

import '../data/repositories/auth_repository.dart';
import '../presentation/controller/login_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());

    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
    );
  }
}
