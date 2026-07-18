import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../orders/data/models/order_model.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key, required this.order});

  final OrderModel order;

  Future<void> _openGoogleMaps() async {
    if (order.latitude == null || order.longitude == null) return;

    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Location",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 15),

            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.red),
              title: Text(order.shopName),
              subtitle: Text(order.shopAddress),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (order.latitude != null && order.longitude != null)
                    ? _openGoogleMaps
                    : null,
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
