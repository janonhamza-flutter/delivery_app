import 'package:delivery_app/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});

  final OrderModel order;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Get.toNamed(AppRoutes.orderDetails, arguments: order);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  const Icon(Icons.local_shipping, color: AppColors.primary),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "Order #${order.id}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(order.status),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Padding(
                padding: EdgeInsets.only(left: 34),
                child: Text(
                  order.type,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 10),
                  Text(order.customerName),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(Icons.location_on_outlined),
                  SizedBox(width: 10),
                  Expanded(child: Text(order.shopAddress)),
                ],
              ),

              const SizedBox(height: 15),

              const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
