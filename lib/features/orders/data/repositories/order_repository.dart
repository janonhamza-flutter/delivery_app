import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class OrdersRepository {
  final DioService dioService;

  OrdersRepository(this.dioService);

  // سنضيف API هنا لاحقًا
  Future<Response> getOrders() async {
    print("Orders Token = ${StorageService.getToken()}");
    return await dioService.getData(
      endpoint: "/delivery/requests",
      token: StorageService.getToken(),
    );
  }
}
