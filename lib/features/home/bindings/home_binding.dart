import 'package:get/get.dart';

import '../data/repositories/home_repository.dart';
import '../presentation/controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeRepository(Get.find()));

    Get.lazyPut(() => HomeController(Get.find()));
  }
}
