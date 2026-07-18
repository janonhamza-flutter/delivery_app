import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../orders/data/models/order_model.dart';
import '../controller/order_details_controller.dart';

import '../widgets/address_card.dart';
import '../widgets/button_action.dart';
import '../widgets/customer_card.dart';
import '../widgets/device_card.dart';

class OrderDetailsPage extends GetView<OrderDetailsController> {
  OrderDetailsPage({super.key});

  final OrderModel order = Get.arguments as OrderModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),

        child: Column(
          children: [
            // status
            Row(
              children: [
                Text(
                  "Status",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(width: 12),

                Chip(
                  backgroundColor: Colors.orange.shade100,
                  label: Text(
                    order.status,
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            CustomerCard(order: order),

            SizedBox(height: 18),

            AddressCard(order: order),

            SizedBox(height: 18),

            DeviceCard(order: order),

            SizedBox(height: 30),

            ActionButtons(order: order),
          ],
        ),
      ),
    );
  }
}
