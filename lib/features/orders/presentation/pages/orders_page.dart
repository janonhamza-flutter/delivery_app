import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';

import '../controller/orders_controller.dart';
import '../widgets/order_item.dart';

class OrdersPage extends GetView<OrdersController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),

        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.orders.isEmpty) {
            return const Center(child: Text("No Orders"));
          }

          return ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (_, index) {
              return OrderItem(order: controller.orders[index]);
            },
          );
        }),
      ),
    );
  }
}
