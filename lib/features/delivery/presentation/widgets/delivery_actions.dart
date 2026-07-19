/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/controller/orders_controller.dart';

class DeliveryActions extends StatelessWidget {
  const DeliveryActions({super.key, required this.order});

  final OrderModel order;

  Future<void> _openGoogleMaps() async {
    if (order.latitude == null || order.longitude == null) {
      Get.snackbar("Location", "No location available for this order.");
      return;
    }

    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    final codeController = TextEditingController();
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openGoogleMaps,
            icon: const Icon(Icons.map),
            label: const Text("Open Google Maps"),
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Get.defaultDialog(
                title: "Confirm Delivery",
                content: TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: "Confirmation Code",
                  ),
                ),
                textConfirm: "Confirm",
                textCancel: "Cancel",
                onConfirm: () {
                  if (codeController.text.trim().isEmpty) {
                    Get.snackbar("Error", "Please enter confirmation code");
                    return;
                  }
                  Get.back();

                  controller.confirmDelivery(
                    orderId: order.id,
                    confirmationCode: codeController.text.trim(),
                  );
                },
              );
            },
            child: const Text("Complete Delivery"),
          ),
        ),
      ],
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../orders/data/models/order_model.dart';
import '../controller/delivery_controller.dart';

class DeliveryActions extends StatelessWidget {
  const DeliveryActions({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActiveDeliveryController>();

    final codeController = TextEditingController();

    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.openGoogleMaps(
                            latitude: order.latitude,
                            longitude: order.longitude,
                          );
                        },
                  icon: const Icon(Icons.map_outlined),
                  label: const Text("Open Map"),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: controller.isActionLoading.value
                      ? null
                      : () async {
                          if (order.status == "accepted") {
                            await controller.updateStatus(
                              orderId: order.id,
                              status: "on_the_way",
                            );
                          } else if (order.status == "on_the_way") {
                            await controller.updateStatus(
                              orderId: order.id,
                              status: "arrived",
                            );
                          }
                        },
                  icon: const Icon(Icons.location_on),
                  label: Text(
                    order.status == "accepted"
                        ? "I'm On The Way"
                        : "I've Arrived",
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      Get.defaultDialog(
                        title: "Confirm Delivery",
                        content: TextField(
                          controller: codeController,
                          decoration: const InputDecoration(
                            labelText: "Confirmation Code",
                            prefixIcon: Icon(Icons.password),
                          ),
                        ),
                        textConfirm: "Confirm",
                        textCancel: "Cancel",
                        onConfirm: () {
                          Get.back();

                          controller.confirmDelivery(
                            orderId: order.id,
                            confirmationCode: codeController.text,
                          );
                        },
                      );
                    },
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Complete Delivery",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
