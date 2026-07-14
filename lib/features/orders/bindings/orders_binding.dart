import 'package:get/get.dart';

import '../data/repositories/order_repository.dart';
import '../presentation/controller/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrdersRepository(Get.find()));

    Get.lazyPut(() => OrdersController(Get.find()));
  }
}
