import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/otp_controller.dart';

class ResendCode extends GetView<OtpController> {
  const ResendCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.seconds.value > 0) {
        return Text(
          "Resend code in ${controller.seconds.value}s",
          style: const TextStyle(color: Colors.grey),
        );
      }

      return TextButton(
        onPressed: controller.resendCode,
        child: const Text("Resend Code"),
      );
    });
  }
}
