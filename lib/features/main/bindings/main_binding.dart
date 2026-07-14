import 'package:get/get.dart';

import '../../orders/data/repositories/order_repository.dart';
import '../../orders/presentation/controller/orders_controller.dart';
import '../../profile/data/repositories/profile_repository.dart';
import '../../profile/presentaion/controller/profile_controller.dart';
import '../presentation/controller/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());

    Get.lazyPut(() => OrdersRepository(Get.find()));
    Get.lazyPut(() => OrdersController(Get.find()));

    Get.lazyPut(() => ProfileRepository(Get.find()));
    Get.lazyPut(() => ProfileController(Get.find()));
  }
}
