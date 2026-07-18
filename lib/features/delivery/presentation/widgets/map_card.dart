/*import 'package:flutter/material.dart';
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
}*/

import 'package:flutter/material.dart';

import '../../../orders/data/models/order_model.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            /// Placeholder مؤقت حتى نربط Google Map
            Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.map, size: 80, color: Colors.grey),
              ),
            ),

            /// اسم المتجر
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.95),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.shopName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            order.shopAddress,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
