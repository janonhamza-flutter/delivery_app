import 'package:delivery_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashDelivery extends StatelessWidget {
  const SplashDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xff42E76D).withOpacity(.15),
          ),
        ),

        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xff42E76D).withOpacity(.25),
          ),
        ),

        Image.asset(
          AppAssets.deliveryBoy,
          height: 220,
        ).animate().slideY(begin: .5, end: 0, duration: 900.ms).fade(),
      ],
    );
  }
}
