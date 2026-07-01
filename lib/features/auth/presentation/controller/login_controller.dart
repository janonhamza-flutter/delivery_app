import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {
  LoginController(this.authRepository);

  final AuthRepository authRepository;

  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void continueLogin() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // API لاحقاً

    Get.toNamed(AppRoutes.otp);
  }

  @override
  void onClose() {
    phoneController.dispose();

    super.onClose();
  }
}
