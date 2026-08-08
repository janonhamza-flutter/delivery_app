import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class HomeRepository {
  final DioService dioService;

  HomeRepository(this.dioService);

  /// GET /delivery/earnings
  Future<Response> getEarnings() async {
    final token = StorageService.getToken();
    return await dioService.getData(
      endpoint: '/delivery/earnings',
      token: token,
    );
  }
}
