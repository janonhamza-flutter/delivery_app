import 'package:delivery_app/core/services/error_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  LoginController(this.authRepository);

  final AuthRepository authRepository;

  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  Future<void> sendOtp() async {
    print("sendOtp called");

    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      // تنظيف الرقم
      String phone = phoneController.text.trim();

      // إزالة الصفر إذا كان موجود
      if (phone.startsWith("0")) {
        phone = phone.substring(1);
      }

      // إضافة مفتاح سوريا
      phone = "+963$phone";

      print("Phone Sent: $phone");
      print("Before API");

      await authRepository.sendOtp(phone: phone);
      final response = await authRepository.sendOtp(phone: phone);
      print(response.data);

      print("API Success");

      Get.toNamed(AppRoutes.otp, arguments: phone);
    } on DioException catch (e) {
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");
      print("Message: ${e.message}");

      // Get.snackbar("Error", e.response?.data["message"] ?? "Unknown Error");

      Get.snackbar(
        "تنبيه",
        ErrorHandler.getMessage(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
