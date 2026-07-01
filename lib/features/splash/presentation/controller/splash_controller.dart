import 'package:delivery_app/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      debugPrint("Navigate To Login");
      Get.offAllNamed(AppRoutes.login);
    });
  }
}
