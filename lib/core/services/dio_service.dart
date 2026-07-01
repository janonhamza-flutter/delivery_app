import 'package:dio/dio.dart';

class DioService {
  late Dio dio;

  DioService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://shamsung.haderin.sy/api/v1",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
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
  }) async {
    return await dio.post(endpoint, data: data);
  }
}
