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
