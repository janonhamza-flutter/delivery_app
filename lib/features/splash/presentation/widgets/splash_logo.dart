import 'package:delivery_app/core/constants/app_asstes.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.splashBackground, width: 220),

        const SizedBox(height: 30),

        const Text(AppStrings.appName, style: AppTextStyles.splashTitle),

        const SizedBox(height: 10),

        const Text("Fast • Safe • Reliable", style: AppTextStyles.body),
      ],
    );
  }
}
