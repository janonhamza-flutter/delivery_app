import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class HistoryRepository {
  final DioService dioService;

  HistoryRepository(this.dioService);

  /// GET /delivery/history?page={page}
  Future<Response> getHistory({int page = 1}) async {
    final token = StorageService.getToken();
    return await dioService.getData(
      endpoint: '/delivery/history?page=$page',
      token: token,
    );
  }
}
