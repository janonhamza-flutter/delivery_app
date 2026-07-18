import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../orders/data/models/order_model.dart';

class CustomerInfoCard extends StatelessWidget {
  CustomerInfoCard({super.key, required this.order});

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
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(order.customerName),
        subtitle: Text(order.customerPhone),
        trailing: IconButton(
          onPressed: _callCustomer,
          icon: const Icon(Icons.call, color: Colors.green),
        ),
      ),
    );
  }
}
