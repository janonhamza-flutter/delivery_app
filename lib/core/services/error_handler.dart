import 'package:dio/dio.dart';

class ErrorHandler {
  static String getMessage(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return "غير مصرح. الرجاء تسجيل الدخول مرة أخرى.";

      case 403:
        return "الحساب غير مفعل، يرجى التواصل مع الإدارة.";

      case 404:
        return "المورد غير موجود.";

      case 422:
        return e.response?.data["message"] ?? "البيانات المدخلة غير صحيحة.";

      case 500:
        return "حدث خطأ في الخادم.";

      default:
        return "تحقق من اتصال الإنترنت وحاول مرة أخرى.";
    }
  }
}
