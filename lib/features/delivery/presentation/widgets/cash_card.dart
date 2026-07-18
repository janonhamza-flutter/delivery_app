import 'package:flutter/material.dart';

import '../../../orders/data/models/order_model.dart';

class CashCard extends StatelessWidget {
  const CashCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final bool isCash = order.paymentMethod == "cash_on_delivery";

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text("Payment Method", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 15),

            Icon(
              isCash ? Icons.payments : Icons.credit_card,
              size: 40,
              color: isCash ? Colors.green : Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(
              isCash ? "Cash On Delivery" : "Prepaid",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
