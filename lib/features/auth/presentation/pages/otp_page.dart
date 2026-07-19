import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controller/otp_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/otp_pin_field.dart';
import '../widgets/resend_code.dart';

class OtpPage extends GetView<OtpController> {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),

          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "Verify OTP",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Text(
                "Enter the verification code sent to",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
              const SizedBox(height: 8),

              Text(
                " ${controller.phone}",
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 45),

              OtpPinField(controller: controller.otpController),

              const SizedBox(height: 35),

              const Center(child: ResendCode()),

              const Spacer(),

              AuthButton(onPressed: controller.verifyOtp),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
