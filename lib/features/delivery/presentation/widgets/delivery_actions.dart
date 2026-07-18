import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../orders/data/models/order_model.dart';

class DeliveryActions extends StatelessWidget {
  const DeliveryActions({super.key, required this.order});

  final OrderModel order;

  Future<void> _openGoogleMaps() async {
    if (order.latitude == null || order.longitude == null) {
      Get.snackbar("Location", "No location available for this order.");
      return;
    }

    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openGoogleMaps,
            icon: const Icon(Icons.map),
            label: const Text("Open Google Maps"),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Get.snackbar(
                "Coming Soon",
                "Complete Delivery API is not available yet.",
              );
            },
            child: const Text("Complete Delivery"),
          ),
        ),
      ],
    );
  }
}
