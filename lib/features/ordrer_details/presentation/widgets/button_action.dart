import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {},
            child: const Text("Accept Order", style: TextStyle(fontSize: 18)),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.activeDelivery);
            },
            child: const Text("Reject Order", style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
