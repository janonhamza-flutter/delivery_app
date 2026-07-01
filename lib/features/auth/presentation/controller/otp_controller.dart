import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final otpController = TextEditingController();

  final isLoading = false.obs;

  final seconds = 30.obs;

  @override
  void onInit() {
    super.onInit();

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

  void resendCode() {
    seconds.value = 30;
    startTimer();

    // API later
  }

  void verifyOtp() {
    if (otpController.text.length != 4) {
      Get.snackbar("Error", "Please enter the verification code");
      return;
    }

    // Verify API later
    // Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
