import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class OrdersRepository {
  final DioService dioService;

  OrdersRepository(this.dioService);

  Future<Response> getOrders({int page = 1}) async {
    return await dioService.getData(
      endpoint: "/delivery/requests?page=$page",
      token: StorageService.getToken(),
    );
  }

  /// GET /delivery/requests/{id}
  /// Returns the delivery the worker owns (accepted/on_the_way/arrived).
  Future<Response> getRequestDetails({required int id}) async {
    return await dioService.getData(
      endpoint: "/delivery/requests/$id",
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

  Future<Response> rejectOrder({required int orderId, String? reason}) async {
    return await dioService.postData(
      endpoint: "/delivery/requests/$orderId/reject",
      token: StorageService.getToken(),
      data: reason != null && reason.trim().isNotEmpty
          ? {"reason": reason.trim()}
          : {},
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

  /// POST /delivery/requests/{id}/collect-cash
  /// Records cash collection. Only valid for:
  /// status=delivered, payment_method=cash_on_delivery, cash_collected=false.
  Future<Response> collectCash({
    required int orderId,
    required double cashAmount,
  }) async {
    return await dioService.postData(
      endpoint: "/delivery/requests/$orderId/collect-cash",
      token: StorageService.getToken(),
      data: {"cash_amount": cashAmount},
    );
  }
}
