import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            height: 1.5,
          ),
          children: const [
            TextSpan(text: "By continuing, you agree to our\n"),
            TextSpan(
              text: "Terms & Conditions",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
