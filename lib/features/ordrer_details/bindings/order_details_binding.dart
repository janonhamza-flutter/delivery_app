import 'package:get/get.dart';

import '../data/repositories/order_details_repository.dart';
import '../presentation/controller/order_details_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderDetailsRepository(Get.find()));

    Get.lazyPut(() => OrderDetailsController(Get.find()));
  }
}
