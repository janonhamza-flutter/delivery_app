/*import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../data/repositories/auth_repository.dart';

class OtpController extends GetxController {
  OtpController(this.authRepository);

  final AuthRepository authRepository;

  final otpController = TextEditingController();

  final isLoading = false.obs;

  final seconds = 30.obs;

  late String phone;

  @override
  void onInit() {
    super.onInit();

    phone = Get.arguments;
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (seconds.value > 0) {
        seconds.value--;
        return true;
      }

      return false;
    });
  }

  Future<void> resendCode() async {
    seconds.value = 30;
    startTimer();

    await authRepository.sendOtp(phone: phone);
    // API later
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 5) {
      Get.snackbar("Error", "Please enter the verification code");
      return;
    }

    // Verify API later
    // Get.offAllNamed(AppRoutes.home);

    try {
      isLoading.value = true;

      final response = await authRepository.verifyOtp(
        phone: phone,
        code: otpController.text,
      );

      print(response.data);

      // سنحفظ التوكن لاحقًا

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}*/

import 'package:delivery_app/core/services/error_handler.dart';
import 'package:delivery_app/core/services/notification_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/repositories/auth_repository.dart';

class OtpController extends GetxController {
  OtpController(this.authRepository);

  final AuthRepository authRepository;

  final otpController = TextEditingController();

  final isLoading = false.obs;

  final seconds = 30.obs;

  late String phone;

  @override
  void onInit() {
    super.onInit();

    phone = Get.arguments;
    startTimer();
  }

  void startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (seconds.value > 0) {
        seconds.value--;
        return true;
      }

      return false;
    });
  }

  Future<void> resendCode() async {
    try {
      seconds.value = 30;
      startTimer();

      await authRepository.sendOtp(phone: phone);

      Get.snackbar("Success", "OTP sent again successfully");
    } on DioException catch (e) {
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");

      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? "Something went wrong",
      );
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.length != 5) {
      Get.snackbar("Error", "Please enter the 5-digit verification code");
      return;
    }

    try {
      isLoading.value = true;

      print("Phone: $phone");
      print("OTP: ${otpController.text}");

      final response = await authRepository.verifyOtp(
        phone: phone,
        code: otpController.text,
      );

      print("Verify Success");
      print(response.data);

      // سنحفظ التوكن لاحقًا
      final token = response.data["data"]["token"];
      StorageService.saveToken(token);

      final fcmToken = await NotificationService.getDeviceToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        try {
          await authRepository.updateFcmToken(fcmToken: fcmToken);
        } catch (e) {
          print("FCM update failed: $e");
        }
      }

      Get.offAllNamed(AppRoutes.main);
    } on DioException catch (e) {
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");
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
