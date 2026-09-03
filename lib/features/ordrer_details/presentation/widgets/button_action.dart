import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/data/models/order_model.dart';
import '../../../orders/presentation/controller/orders_controller.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key, required this.order});

  final OrderModel order;

  /// Bottom sheet — worker picks an ETA then confirms acceptance.
  void _showAcceptSheet(BuildContext context, OrdersController controller) {
    const etaOptions = [15, 30, 45, 60, 90, 120];
    int selectedMinutes = 30;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title row
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.secondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'orderDetails.confirmAcceptTitle'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'orderDetails.selectEta'.tr,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ETA chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: etaOptions.map((minutes) {
                      final isSelected = selectedMinutes == minutes;
                      final label = _formatEtaLabel(minutes);

                      return GestureDetector(
                        onTap: () => setState(() => selectedMinutes = minutes),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondary
                                : AppColors.scaffold,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.secondary
                                  : AppColors.lightGrey,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.darkGrey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),

                  // ETA preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Builder(
                      builder: (_) {
                        final eta = DateTime.now().add(
                          Duration(minutes: selectedMinutes),
                        );
                        return Row(
                          children: [
                            const Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'orderDetails.expectedArrival'.trArgs([
                                DateFormat('hh:mm a').format(eta),
                              ]),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radius,
                            ),
                          ),
                        ),
                        onPressed: controller.isActionLoading.value
                            ? null
                            : () {
                                Get.back();
                                final estimatedTime =
                                    DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                      DateTime.now().add(
                                        Duration(minutes: selectedMinutes),
                                      ),
                                    );
                                controller.acceptOrder(
                                  order: order,
                                  estimatedTime: estimatedTime,
                                );
                              },
                        child: controller.isActionLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'orderDetails.confirmAccept'.tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Dialog — worker may reject the request, with an optional reason.
  void _showRejectDialog(BuildContext context, OrdersController controller) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.cancel_rounded,
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'orderDetails.rejectOrderTitle'.tr,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'orderDetails.rejectReasonLabel'.tr,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'orderDetails.rejectReasonHint'.tr,
                filled: true,
                fillColor: AppColors.scaffold,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'common.cancel'.tr,
              style: const TextStyle(color: AppColors.darkGrey),
            ),
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radius),
                ),
              ),
              onPressed: controller.isActionLoading.value
                  ? null
                  : () {
                      final reason = reasonController.text.trim();
                      Get.back();
                      controller.rejectOrder(
                        orderId: order.id,
                        reason: reason.isEmpty ? null : reason,
                      );
                    },
              child: Text('orderDetails.confirmReject'.tr),
            ),
          ),
        ],
      ),
    );
  }

  String _formatEtaLabel(int minutes) {
    if (minutes < 60) {
      return 'orderDetails.etaMinutesSingular'.trPlural(
        'orderDetails.etaMinutesPlural',
        minutes,
        ['$minutes'],
      );
    }
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    if (remainder == 0) {
      return 'orderDetails.etaHoursSingular'.trPlural(
        'orderDetails.etaHoursPlural',
        hours,
        ['$hours'],
      );
    }
    return 'orderDetails.etaHoursWithMinutes'.trArgs([
      '$hours',
      '$remainder',
    ]);
  }

  bool _canAcceptOrder() {
    if (order.type != 'device_pickup') {
      return true;
    }

    // Picking the device up from the customer (before repair) has no
    // completion requirement — only returning it after repair does.
    if (order.direction != 'shop_to_customer') {
      return true;
    }

    final maintenanceStatus = order.maintenanceStatus?.trim().toLowerCase();
    return maintenanceStatus == 'completed';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    return Obx(() {
      final isLoading = controller.isActionLoading.value;
      final canAccept = _canAcceptOrder();

      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: AppSizes.buttonHeight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () => _showRejectDialog(context, controller),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel_rounded, size: 18),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'orderDetails.rejectOrder'.tr,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                  ),
                ),
                onPressed: isLoading || !canAccept
                    ? null
                    : () => _showAcceptSheet(context, controller),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 18),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'orderDetails.acceptOrder'.tr,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
