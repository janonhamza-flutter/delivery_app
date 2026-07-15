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
        /// Accept Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.activeDelivery);
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              "Accept Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 15),

        /// Reject Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Get.back(); // أو ضعي الكود المناسب للرفض لاحقًا
            },
            icon: const Icon(Icons.close),
            label: const Text(
              "Reject Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
