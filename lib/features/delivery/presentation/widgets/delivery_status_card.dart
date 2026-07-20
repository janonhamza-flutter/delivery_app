import 'package:flutter/material.dart';

import '../../../orders/data/models/order_model.dart';

class DeliveryStatusCard extends StatelessWidget {
  const DeliveryStatusCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String text;

    switch (order.status) {
      case "accepted":
        color = Colors.green;
        icon = Icons.check_circle;
        text = "Accepted";
        break;

      case "arrived":
        color = Colors.orange;
        icon = Icons.location_on;
        text = "Arrived";
        break;

      case "delivered":
        color = Colors.blue;
        icon = Icons.done_all;
        text = "Delivered";
        break;

      default:
        color = Colors.grey;
        icon = Icons.schedule;
        text = order.status;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delivery Status",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 4),

                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
