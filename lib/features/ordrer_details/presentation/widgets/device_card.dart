import 'package:flutter/material.dart';

import '../../../orders/data/models/order_model.dart';

class DeviceCard extends StatelessWidget {
  DeviceCard({super.key, required this.order});

  final OrderModel order;

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
              "Order Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.local_shipping),
              title: Text(order.type),
              subtitle: Text("Payment: ${order.paymentMethod}"),
            ),

            const SizedBox(height: 10),

            const Text("Shop", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 5),

            Text(order.shopName),
          ],
        ),
      ),
    );
  }
}
