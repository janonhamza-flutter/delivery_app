import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

import '../controller/splash_controller.dart';
import '../widgets/splash_delivery.dart';
import '../widgets/splash_loading.dart';
import '../widgets/splash_logo.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [Color(0xff123A86), AppColors.primary],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),

            child: Column(
              children: [
                const Spacer(),

                const SplashLogo(),

                const SizedBox(height: 35),

                const SplashDelivery(),

                const Spacer(),

                const SplashLoading(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
