import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/login_controller.dart';
import '../widgets/auth_button.dart';
import '../widgets/login_header.dart';
import '../widgets/phone_text_field.dart';
import '../widgets/terms.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.padding),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      /// Logo + Welcome
                      const LoginHeader(),

                      const SizedBox(height: 45),

                      /// Phone Field
                      PhoneTextField(controller: controller.phoneController),

                      const SizedBox(height: 25),

                      /// Continue Button
                      Obx(
                        () => AuthButton(
                          onPressed: controller.sendOtp,
                          isLoading: controller.isLoading.value, text: 'Send phone',
                        ),
                      ),

                      const SizedBox(height: 24),
                      const TermsWidget(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
