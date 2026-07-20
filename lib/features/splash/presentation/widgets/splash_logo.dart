import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Sham",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  TextSpan(
                    text: "Sung",
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF42E76D),
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(begin: const Offset(.8, .8), end: const Offset(1, 1)),

        const SizedBox(height: 30),

        const Text(
          AppStrings.appName,
          style: AppTextStyles.splashTitle,
        ).animate(delay: 400.ms).fade().moveY(begin: 25, end: 0),

        const SizedBox(height: 10),

        const Text("Fast • Safe • Reliable", style: AppTextStyles.body),
      ],
    );
  }
}
