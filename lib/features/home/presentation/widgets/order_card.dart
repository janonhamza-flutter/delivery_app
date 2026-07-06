import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Order #1054",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Row(
              children: [
                Icon(Icons.person, size: 18),

                SizedBox(width: 8),

                Text("Ahmed Ali"),
              ],
            ),

            const SizedBox(height: 8),

            const Row(
              children: [
                Icon(Icons.location_on, size: 18),

                SizedBox(width: 8),

                Expanded(child: Text("Mazzeh - Damascus")),
              ],
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),

                onPressed: () {},

                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
