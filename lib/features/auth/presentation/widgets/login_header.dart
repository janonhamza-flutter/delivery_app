import 'package:delivery_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logo, width: 120),

        const SizedBox(height: 20),

        const Text("Welcome Back", style: AppTextStyles.pageTitle),

        const SizedBox(height: 8),

        const Text(
          "Enter your phone number to continue",
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
