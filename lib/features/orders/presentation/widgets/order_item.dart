import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});

  final OrderModel order;

  // ── Type helpers ────────────────────────────────────────────────────────────
  IconData get _typeIcon {
    switch (order.type) {
      case 'device_pickup':
        return Icons.phone_iphone_rounded;
      case 'accessory_delivery':
        return Icons.headphones_rounded;
      case 'maintenance_return':
        return Icons.build_rounded;
      default:
        return Icons.local_shipping_rounded;
    }
  }

  String get _typeLabel {
    switch (order.type) {
      case 'device_pickup':
        return 'Device Pickup';
      case 'accessory_delivery':
        return 'Accessory';
      case 'maintenance_return':
        return 'Maint. Return';
      default:
        return order.type.replaceAll('_', ' ');
    }
  }

  Color get _typeColor {
    switch (order.type) {
      case 'device_pickup':
        return AppColors.primary;
      case 'accessory_delivery':
        return AppColors.info;
      case 'maintenance_return':
        return AppColors.warning;
      default:
        return AppColors.grey;
    }
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.orderDetails, arguments: order),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top strip (colored by type) ─────────────────────────────
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: _typeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Row 1: icon + title + time ──────────────────────
                  Row(
                    children: [
                      // Type icon
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(_typeIcon, color: _typeColor, size: 22),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Request #${order.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xff1A1A2E),
                                  ),
                                ),
                                const Spacer(),
                                // time ago
                                if (order.createdAt.isNotEmpty)
                                  Text(
                                    _formatTime(order.createdAt),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xffAAAAAA),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            // type chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _typeColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _typeLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _typeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xffF3F4F6)),
                  const SizedBox(height: 12),

                  // ── Row 2: customer + phone ─────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          order.customerName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff1A1A2E),
                          ),
                        ),
                      ),
                      // phone chip
                      GestureDetector(
                        onTap: () {}, // launch phone
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.phone_rounded,
                                size: 13,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                order.customerPhone,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Row 3: shop address ─────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 17,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.shopName,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff1A1A2E),
                              ),
                            ),
                            if (order.shopAddress.isNotEmpty)
                              Text(
                                order.shopAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff9E9E9E),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ── Notes (if any) ──────────────────────────────────
                  if (order.notes != null && order.notes!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              order.notes!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // ── Bottom: payment + arrow ─────────────────────────
                  Row(
                    children: [
                      // payment method
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: order.paymentMethod == 'cash_on_delivery'
                              ? AppColors.warning.withValues(alpha: 0.1)
                              : AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              order.paymentMethod == 'cash_on_delivery'
                                  ? Icons.payments_rounded
                                  : Icons.credit_card_rounded,
                              size: 13,
                              color: order.paymentMethod == 'cash_on_delivery'
                                  ? AppColors.warning
                                  : AppColors.info,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              order.paymentMethod == 'cash_on_delivery'
                                  ? 'Cash on Delivery'
                                  : 'Prepaid',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: order.paymentMethod == 'cash_on_delivery'
                                    ? AppColors.warning
                                    : AppColors.info,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // View details
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'View',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
