import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class OrderDetailsRepository {
  final DioService dioService;

  OrderDetailsRepository(this.dioService);

  /// GET /delivery/requests/{id}
  /// Returns details of a delivery the worker owns OR an unassigned pending request.
  Future<Response> getRequestDetails({required int requestId}) async {
    return await dioService.getData(
      endpoint: "/delivery/requests/$requestId",
      token: StorageService.getToken(),
    );
  }
}
