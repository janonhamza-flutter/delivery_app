import 'package:flutter/material.dart';

import '../../../orders/data/models/order_model.dart';

class CustomerCard extends StatelessWidget {
  CustomerCard({super.key, required this.order});

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
              "Customer",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(order.customerName),
              subtitle: Text(order.customerPhone),
              trailing: IconButton(
                onPressed: () {
                  print(order.customerPhone);
                },
                icon: const Icon(Icons.call, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
