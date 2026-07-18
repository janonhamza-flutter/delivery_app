import 'dart:io';

import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';

import '../../../../core/utils/app_snackbar.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  OrdersController(this.repository);

  final OrdersRepository repository;

  final isLoading = false.obs;
  final isActionLoading = false.obs;

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
    required OrderModel order,
    required String estimatedTime,
  }) async {
    try {
      isActionLoading.value = true;
      print("Accept Order ID = $order");
      print("Estimated Time = $estimatedTime");

      final response = await repository.acceptOrder(
        orderId: order.id,
        estimatedTime: estimatedTime,
      );
      print(response.data);

      AppSnackbar.success(response.data["message"]);

      await getOrders();

      Get.offNamed(AppRoutes.activeDelivery, arguments: order);
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> rejectOrder({required int orderId}) async {
    try {
      isActionLoading.value = true;
      final response = await repository.rejectOrder(orderId: orderId);

      AppSnackbar.success(response.data["message"]);

      getOrders();

      Get.back();
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> confirmDelivery({
    required int orderId,
    String? confirmationCode,
    File? image,
  }) async {
    try {
      isActionLoading.value = true;

      final response = await repository.confirmDelivery(
        orderId: orderId,
        confirmationCode: confirmationCode,
        image: image,
      );

      AppSnackbar.success(response.data["message"]);

      getOrders();

      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }
}
