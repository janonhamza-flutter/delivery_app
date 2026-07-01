import 'package:delivery_app/core/constants/app_asstes.dart';
import 'package:flutter/material.dart';

class SplashDelivery extends StatelessWidget {
  const SplashDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.deliveryBoy, width: 220);
  }
}
