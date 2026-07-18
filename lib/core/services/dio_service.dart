import 'package:dio/dio.dart';

class DioService {
  late Dio dio;

  DioService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://shamsung.haderin.sy/api/v1",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );
  }

  Future<Response> postData({
    required String endpoint,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    return await dio.post(
      endpoint,
      data: data,
      options: Options(
        headers: token == null ? null : {"Authorization": "Bearer $token"},
      ),
    );
  }

  Future<Response> getData({required String endpoint, String? token}) async {
    return await dio.get(
      endpoint,
      options: Options(
        headers: token == null ? null : {"Authorization": "Bearer $token"},
      ),
    );
  }

  Future<Response> postFormData({
    required String endpoint,
    required FormData data,
    String? token,
  }) async {
    return await dio.post(
      endpoint,
      data: data,
      options: Options(
        headers: token == null
            ? null
            : {"Authorization": "Bearer $token", "Accept": "application/json"},
      ),
    );
  }
}
