import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DeliveryActions extends StatelessWidget {
  const DeliveryActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},

            icon: const Icon(Icons.map),

            label: const Text("Open Google Maps"),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {},
            child: const Text("Complete Delivery"),
          ),
        ),
      ],
    );
  }
}
