import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 15),

            const Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(child: Text("Mazzeh Street\nDamascus")),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.map),
                label: const Text("Open Google Maps"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
