import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';

import '../../../orders/data/models/order_model.dart';
import '../controller/delivery_controller.dart';
import '../widgets/customer_info_card.dart';
import '../widgets/delivery_status_card.dart';
import '../widgets/map_card.dart';
import '../widgets/cash_card.dart';
import '../widgets/delivery_actions.dart';

class ActiveDeliveryPage extends GetView<ActiveDeliveryController> {
  ActiveDeliveryPage({super.key});

  final OrderModel order = Get.arguments as OrderModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Delivery")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            DeliveryStatusCard(order: order),

            const SizedBox(height: 20),

            CustomerInfoCard(order: order),

            const SizedBox(height: 20),

            MapCard(order: order),

            const SizedBox(height: 20),

            CashCard(order: order),

            const SizedBox(height: 30),

            DeliveryActions(order: order),
          ],
        ),
      ),
    );
  }
}
