import 'package:dio/dio.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../core/services/storage_service.dart';

class ProfileRepository {
  final DioService dioService;

  ProfileRepository(this.dioService);

  Future<Response> getProfile() async {
    return await dioService.getData(
      endpoint: "/delivery/profile",
      token: StorageService.getToken(),
    );
  }

  Future<Response> logout() async {
    return await dioService.postData(
      endpoint: "/delivery/logout",
      data: {},
      token: StorageService.getToken(),
    );
  }
}
