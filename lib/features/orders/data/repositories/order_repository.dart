import 'dart:io';

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

  Future<Response> acceptOrder({
    required int orderId,
    required String estimatedTime,
  }) async {
    return await dioService.postData(
      endpoint: "/delivery/requests/$orderId/accept",
      token: StorageService.getToken(),
      data: {"estimated_time": estimatedTime},
    );
  }

  Future<Response> rejectOrder({required int orderId}) async {
    return await dioService.postData(
      endpoint: "/delivery/requests/$orderId/reject",
      token: StorageService.getToken(),
      data: {},
    );
  }

  Future<Response> updateStatus({
    required int orderId,
    required String status,
  }) async {
    return await dioService.postData(
      endpoint: "/delivery/requests/$orderId/status",
      token: StorageService.getToken(),
      data: {"status": status},
    );
  }

  Future<Response> confirmDelivery({
    required int orderId,
    String? confirmationCode,
    File? image,
  }) async {
    final token = StorageService.getToken();

    FormData formData = FormData();

    if (confirmationCode != null && confirmationCode.isNotEmpty) {
      formData.fields.add(MapEntry("confirmation_code", confirmationCode));
    }

    if (image != null) {
      formData.files.add(
        MapEntry("image", await MultipartFile.fromFile(image.path)),
      );
    }

    return await dioService.postFormData(
      endpoint: "/delivery/requests/$orderId/confirm",
      data: formData,
      token: token,
    );
  }
}
