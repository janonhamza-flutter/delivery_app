import 'package:delivery_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controller/splash_controller.dart';
import '../widgets/animated_loading_bar.dart';
import '../widgets/splash_loading.dart';
import '../widgets/splash_logo.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final controller = Get.put(SplashController());

  // Derived tones from the app's own primary color, kept in one place
  // so the splash always matches the active theme.
  static final Color _deepPrimary = Color.lerp(
    AppColors.primary,
    Colors.black,
    0.55,
  )!;
  static final Color _softPrimary = Color.lerp(
    AppColors.primary,
    Colors.white,
    0.18,
  )!;

  @override
  Widget build(BuildContext context) {
    // Use a shared loading duration so progress bar and logo animations match
    final loadingDuration = const Duration(seconds: 5);

    return Scaffold(
      backgroundColor: _deepPrimary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.2,
            colors: [AppColors.primary, _deepPrimary],
          ),
        ),
        // Brand/splash content is forced left-to-right so the logo and
        // loader always stay centered, regardless of the app's active
        // locale/text direction.
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              // Soft ambient glows.
              Positioned(
                top: -80,
                left: -60,
                child: _Glow(
                  color: AppColors.secondary.withOpacity(0.12),
                  size: 220,
                ),
              ),
              Positioned(
                bottom: -100,
                right: -60,
                child: _Glow(color: _softPrimary.withOpacity(0.22), size: 260),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.padding,
                    vertical: 24,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SplashLogo(duration: loadingDuration),
                        const SizedBox(height: 56),
                        const SplashLoading(),
                        const SizedBox(height: 16),
                        AnimatedLoadingBar(duration: loadingDuration),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
