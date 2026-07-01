import 'package:delivery_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class SplashDelivery extends StatelessWidget {
  const SplashDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Image.asset(
      AppAssets.deliveryBoy,
      height: MediaQuery.of(context).size.height * 0.28,
      fit: BoxFit.contain,
    );
  }
}
