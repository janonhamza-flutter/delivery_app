import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  OrdersController(this.repository);

  final OrdersRepository repository;

  final isLoading = false.obs;

  final orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> getOrders() async {
    try {
      isLoading.value = true;

      final response = await repository.getOrders();

      final list = response.data["data"] as List;

      for (var item in list) {
        try {
          final order = OrderModel.fromJson(item);
          orders.add(order);
          print("Loaded Order ${order.id}");
        } catch (e, s) {
          print("ERROR PARSING ORDER");
          print(item);
          print(e);
          print(s);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptOrder({
    required int orderId,
    required String estimatedTime,
  }) async {
    try {
      print("Accept Order ID = $orderId");
      print("Estimated Time = $estimatedTime");

      final response = await repository.acceptOrder(
        orderId: orderId,
        estimatedTime: estimatedTime,
      );
      print(response.data);

      Get.snackbar("Success", response.data["message"]);

      await getOrders();

      Get.offNamed(
        AppRoutes.activeDelivery,
        arguments: orders.firstWhere(
          (e) => e.id == orderId,
          orElse: () => throw Exception("Order not found"),
        ),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> rejectOrder({required int orderId}) async {
    try {
      final response = await repository.rejectOrder(orderId: orderId);

      Get.snackbar("Success", response.data["message"]);

      getOrders();

      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
