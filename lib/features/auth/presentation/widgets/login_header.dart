import 'package:delivery_app/core/constants/app_assets.dart';
import 'package:delivery_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logo, width: 120),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Sham",
                style: GoogleFonts.montserrat(
                  color: AppColors.primary,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              TextSpan(
                text: "Sung",
                style: GoogleFonts.montserrat(
                  color: AppColors.secondary,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
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
