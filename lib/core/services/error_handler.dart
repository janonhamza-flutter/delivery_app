import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ErrorHandler {
  static String getMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return 'errors.unauthorized'.tr;

      case 403:
        return 'errors.accountInactive'.tr;

      case 404:
        return 'errors.notFound'.tr;

      case 422:
        return e.response?.data["message"] ?? 'errors.invalidData'.tr;

      case 500:
        return 'errors.serverError'.tr;

      default:
        return 'errors.checkConnection'.tr;
    }
  }
}
