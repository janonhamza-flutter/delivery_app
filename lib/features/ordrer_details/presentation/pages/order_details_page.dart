import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controller/order_details_controller.dart';

import '../widgets/address_card.dart';
import '../widgets/button_action.dart';
import '../widgets/customer_card.dart';
import '../widgets/device_card.dart';

class OrderDetailsPage extends GetView<OrderDetailsController> {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),

        child: Column(
          children: const [
            CustomerCard(),

            SizedBox(height: 18),

            AddressCard(),

            SizedBox(height: 18),

            DeviceCard(),

            SizedBox(height: 30),

            ActionButtons(),
          ],
        ),
      ),
    );
  }
}
