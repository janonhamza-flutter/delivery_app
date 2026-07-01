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
      appBar: AppBar(),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 20),

              const Text(
                "Verify Phone Number",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text("Enter the 4-digit code sent to your phone."),

              const SizedBox(height: 40),

              OtpPinField(controller: controller.otpController),

              const SizedBox(height: 30),

              const Center(child: ResendCode()),

              const Spacer(),

              AuthButton(onPressed: controller.verifyOtp),
            ],
          ),
        ),
      ),
    );
  }
}
