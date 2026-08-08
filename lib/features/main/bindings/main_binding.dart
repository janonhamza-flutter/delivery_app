import 'package:get/get.dart';

import '../../delivery/presentation/controller/delivery_controller.dart';
import '../../history/data/repositories/history_repository.dart';
import '../../history/presentation/controller/history_controller.dart';
import '../../home/data/repositories/home_repository.dart';
import '../../home/presentation/controller/home_controller.dart';
import '../../orders/data/repositories/order_repository.dart';
import '../../orders/presentation/controller/orders_controller.dart';
import '../../profile/data/repositories/profile_repository.dart';
import '../../profile/presentaion/controller/profile_controller.dart';
import '../presentation/controller/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());

    // Home tab — registered here because HomePage lives inside MainController
    // IndexedStack and never navigates via a named route with HomeBinding.
    Get.lazyPut(() => HomeRepository(Get.find()));
    Get.lazyPut(() => HomeController(Get.find()), fenix: true);

    // History — registered here so DeliveryHistorySection (inside HomePage)
    // can access HistoryController without depending on route-level binding.
    Get.lazyPut(() => HistoryRepository(Get.find()));
    Get.lazyPut(() => HistoryController(Get.find()), fenix: true);

    Get.lazyPut(() => OrdersRepository(Get.find()));
    Get.lazyPut(() => OrdersController(Get.find()));

    // ActiveDeliveryController uses OrdersRepository (same instance)
    Get.lazyPut<ActiveDeliveryController>(
      () => ActiveDeliveryController(Get.find<OrdersRepository>()),
      fenix: true,
    );

    Get.lazyPut(() => ProfileRepository(Get.find()));
    Get.lazyPut(() => ProfileController(Get.find()));
  }
}
