import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';

import '../controller/delivery_controller.dart';
import '../widgets/customer_info_card.dart';
import '../widgets/map_card.dart';
import '../widgets/cash_card.dart';
import '../widgets/delivery_actions.dart';

class ActiveDeliveryPage extends GetView<ActiveDeliveryController> {
  const ActiveDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Delivery")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: const Column(
          children: [
            CustomerInfoCard(),

            SizedBox(height: 20),

            MapCard(),

            SizedBox(height: 20),

            CashCard(),

            SizedBox(height: 30),

            DeliveryActions(),
          ],
        ),
      ),
    );
  }
}
