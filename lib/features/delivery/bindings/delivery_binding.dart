import 'package:get/get.dart';

import '../data/repositories/delivery_repository.dart';
import '../presentation/controller/delivery_controller.dart';

class ActiveDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActiveDeliveryRepository(Get.find()));

    Get.lazyPut(() => ActiveDeliveryController(Get.find()));
  }
}
