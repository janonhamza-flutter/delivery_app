import 'package:delivery_app/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2_rounded, color: AppColors.primary),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Order #1054",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: const Text("Pending"),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Row(
              children: [
                Icon(Icons.person_outline),

                SizedBox(width: 10),

                Text("Ahmed Ali"),
              ],
            ),

            const SizedBox(height: 12),

            const Row(
              children: [
                Icon(Icons.location_on_outlined),

                SizedBox(width: 10),

                Expanded(child: Text("Mazzeh - Damascus")),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.orderDetails);
                },

                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
