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

    final maintenanceStatus = order.maintenanceStatus?.trim().toLowerCase();
    return maintenanceStatus == 'completed';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    return Obx(() {
      final isLoading = controller.isActionLoading.value;
      final canAccept = _canAcceptOrder();

      return SizedBox(
        width: double.infinity,
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
                    const Icon(Icons.check_circle_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'orderDetails.acceptOrder'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
