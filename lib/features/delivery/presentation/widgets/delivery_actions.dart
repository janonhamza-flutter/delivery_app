import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/data/models/order_model.dart';
import '../controller/delivery_controller.dart';

class DeliveryActions extends StatelessWidget {
  const DeliveryActions({super.key, required this.order});

  final OrderModel order;

  // ── Confirm delivery sheet ───────────────────────────────────────────────

  void _showConfirmSheet(
    BuildContext context,
    ActiveDeliveryController controller,
    int orderId,
  ) {
    final codeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // ✅ builder receives its own context — viewInsets is always current
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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

              // Title
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'deliveryActions.confirmDelivery'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'deliveryActions.enterConfirmationCode'.tr,
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

              // Confirmation code field
              Text(
                'deliveryActions.confirmationCodeLabel'.tr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'deliveryActions.confirmationCodeHint'.tr,
                  prefixIcon: const Icon(
                    Icons.password_rounded,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.scaffold,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
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
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            Get.back();
                            controller.confirmDelivery(
                              orderId: orderId,
                              confirmationCode:
                                  codeController.text.trim().isEmpty
                                  ? null
                                  : codeController.text.trim(),
                            );
                          },
                    child: controller.isLoading.value
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
                                'deliveryActions.confirmDelivery'.tr,
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
        ),
      ),
    );
  }

  // ── Reject confirmation sheet ────────────────────────────────────────────

  void _showRejectDialog(
    BuildContext context,
    ActiveDeliveryController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cancel_rounded,
                color: AppColors.error,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'deliveryActions.cancelAcceptTitle'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'deliveryActions.cancelAcceptSubtitle'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppSizes.buttonHeight,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.darkGrey,
                        side: const BorderSide(
                          color: AppColors.lightGrey,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radius),
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'common.cancel'.tr,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => SizedBox(
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
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
                                controller.rejectOrder(orderId: order.id);
                              },
                        child: controller.isActionLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'deliveryActions.confirmCancellation'.tr,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActiveDeliveryController>();

    return Obx(() {
      final currentStatus =
          controller.activeOrder.value?.status ?? order.status;
      final currentId = controller.activeOrder.value?.id ?? order.id;

      final isLoading = controller.isLoading.value;
      final isActionLoading = controller.isActionLoading.value;

      // accepted → on_the_way  OR  on_the_way → arrived
      final showStatusBtn =
          currentStatus == 'accepted' || currentStatus == 'on_the_way';

      // ✅ Complete Delivery only enabled when status = 'arrived'
      final canComplete = currentStatus == 'arrived';

      return Column(
        children: [
          if (showStatusBtn) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: isActionLoading
                        ? null
                        : () async {
                            final nextStatus = currentStatus == 'accepted'
                                ? 'on_the_way'
                                : 'arrived';
                            await controller.updateStatus(
                              orderId: currentId,
                              status: nextStatus,
                            );
                          },
                    icon: isActionLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.navigation_rounded, size: 18),
                    label: Text(
                      currentStatus == 'accepted'
                          ? 'deliveryActions.onMyWay'.tr
                          : 'deliveryActions.arrived'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],

          // ── Complete Delivery — enabled only when arrived ─────────────────
          Tooltip(
            message: canComplete ? '' : 'deliveryActions.availableAfterArrive'.tr,
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Dim the button when not yet arrived
                  backgroundColor: canComplete
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.35),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radius),
                  ),
                ),
                // Disabled until arrived
                onPressed: (!canComplete || isLoading)
                    ? null
                    : () => _showConfirmSheet(context, controller, currentId),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'deliveryActions.completeDelivery'.tr,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Lock icon hint when not yet arrived
                          if (!canComplete) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.lock_outline_rounded,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ],
                        ],
                      ),
              ),
            ),
          ),

          // Hint text when locked
          if (!canComplete) ...[
            const SizedBox(height: 6),
            Text(
              'deliveryActions.markArrivedToUnlock'.tr,
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      );
    });
  }
}
