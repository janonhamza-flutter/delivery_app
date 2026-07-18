import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/route/app_routes.dart';

import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/controller/orders_controller.dart';

class ActionButtons extends StatelessWidget {
  ActionButtons({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    return Column(
      children: [
        /// Accept Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              controller.acceptOrder(
                orderId: order.id,
                estimatedTime: DateFormat(
                  "yyyy-MM-dd HH:mm:ss",
                ).format(DateTime.now().add(const Duration(minutes: 30))),
              );
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              "Accept Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 15),

        /// Reject Button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              controller.rejectOrder(
                orderId: order.id,
              ); // أو ضعي الكود المناسب للرفض لاحقًا
            },
            icon: const Icon(Icons.close),
            label: const Text(
              "Reject Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
