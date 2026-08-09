import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/earnings_model.dart';
import '../controller/home_controller.dart';

class ActiveDeliveriesSection extends GetView<HomeController> {
  const ActiveDeliveriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ── Loading ──────────────────────────────────────────────────
      if (controller.isLoading.value) {
        return SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, __) => const _CardSkeleton(),
          ),
        );
      }

      final deliveries = controller.earnings.value?.deliveries ?? [];

      // ── Empty ────────────────────────────────────────────────────
      if (deliveries.isEmpty) {
        return const _EmptyDeliveries();
      }

      // ── Real data ────────────────────────────────────────────────
      return SizedBox(
        height: 185,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: deliveries.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) => _OrderCard(item: deliveries[index]),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order card (real data)
// ─────────────────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final EarningsDeliveryItem item;
  const _OrderCard({required this.item});

  String get _typeLabel {
    switch (item.type) {
      case 'device_pickup':
        return 'home.typeDevicePickup'.tr;
      case 'accessory_delivery':
        return 'home.typeAccessory'.tr;
      case 'maintenance_return':
        return 'home.typeReturn'.tr;
      default:
        return item.type.replaceAll('_', ' ');
    }
  }

  String _formatTime(String? iso) {
    if (iso == null) return '—';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Top row: order id + status ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'home.orderNumber'.trArgs(['${item.id}']),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xff1A1A2E),
                ),
              ),
              // delivered badge (all items here are delivered)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 11,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'status.delivered'.tr,
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Customer name ───────────────────────────────────────
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1A1A2E),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ─── Shop ────────────────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.store_rounded,
                size: 13,
                color: Color(0xff9E9E9E),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff6B7280),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _typeLabel,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          const Divider(height: 1, color: Color(0xffF0F0F0)),
          const SizedBox(height: 8),

          // ─── Bottom: cash + type + time ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cash amount
              if (item.cashAmount != null)
                Row(
                  children: [
                    const Icon(
                      Icons.payments_rounded,
                      size: 13,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${item.cashAmount} SYP',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '',
                    style: TextStyle(
                      color: AppColors.info,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              // confirmed time
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 11,
                    color: Color(0xffAAAAAA),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _formatTime(item.confirmedAt),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xffAAAAAA),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyDeliveries extends StatelessWidget {
  const _EmptyDeliveries();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping_rounded,
              color: AppColors.info,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home.noDeliveriesTitle'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xff1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'home.noDeliveriesSubtitle'.tr,
                  style: const TextStyle(fontSize: 12, color: Color(0xff9E9E9E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton card
// ─────────────────────────────────────────────────────────────────────────────
class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
