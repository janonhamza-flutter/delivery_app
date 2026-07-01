import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/login_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/login_header.dart';
import '../widgets/phone_text_field.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),

            child: Form(
              key: controller.formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const SizedBox(height: 70),

                  /// Logo + Welcome
                  const LoginHeader(),

                  const SizedBox(height: 60),

                  /// Phone Field
                  PhoneTextField(controller: controller.phoneController),

                  const SizedBox(height: 35),

                  /// Continue Button
                  AuthButton(
                    onPressed: () {
                      controller.continueLogin();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
