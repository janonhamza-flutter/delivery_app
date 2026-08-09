import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../orders/data/models/order_model.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key, required this.order});

  final OrderModel order;

  Future<void> _callCustomer() async {
    final Uri uri = Uri(scheme: "tel", path: order.customerPhone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Customer",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue.shade50,
                  child: IconButton(
                    onPressed: _callCustomer,
                    icon: const Icon(Icons.call, color: Colors.blue),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.person, size: 22),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    order.customerName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Icon(Icons.phone_outlined),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    order.customerPhone,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            Row(
              children: [
                const Icon(Icons.local_shipping_outlined),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    order.type.replaceAll("_", " "),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
