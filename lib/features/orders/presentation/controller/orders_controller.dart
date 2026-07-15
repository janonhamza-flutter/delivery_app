import 'package:dio/dio.dart';
import 'package:get/get.dart';

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

      print("Orders Token = ${StorageService.getToken()}");
      final response = await repository.getOrders();

      print(response.data);
      orders.assignAll(
        (response.data["data"] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList(),
      );
      print("Orders Count = ${orders.length}");
    } on DioException catch (e) {
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");
      print("Headers: ${e.requestOptions.headers}");
    } finally {
      isLoading.value = false;
    }
  }
}
