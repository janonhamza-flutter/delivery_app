import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../history/data/models/history_model.dart';
import '../../../history/presentation/controller/history_controller.dart';
import '../../../history/presentation/widgets/history_status_helper.dart';

/// Shows the first 3 history items fetched from the API.
/// "View All History" navigates to the full HistoryPage.
class DeliveryHistorySection extends GetView<HistoryController> {
  const DeliveryHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ── Loading ────────────────────────────────────────────────────
      if (controller.isLoading.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(
              3,
              (_) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        );
      }

      final preview = controller.items.take(3).toList();

      // ── Empty ──────────────────────────────────────────────────────
      if (preview.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.history_rounded, color: AppColors.primary, size: 28),
                SizedBox(width: 14),
                Text(
                  'No delivery history yet.',
                  style: TextStyle(color: Color(0xff6B7280), fontSize: 13),
                ),
              ],
            ),
          ),
        );
      }

      // ── List ───────────────────────────────────────────────────────
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ...preview.map((item) => _HistoryItem(item: item)),
            const SizedBox(height: 4),
            // ── View All button ──────────────────────────────────────
            GestureDetector(
              onTap: () {
                controller.scheduleHistoryRefreshOnOpen();
                Get.toNamed(AppRoutes.history);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View All History',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Single history row — driven by real HistoryItemModel
// ─────────────────────────────────────────────────────────────────────────────
class _HistoryItem extends StatelessWidget {
  final HistoryItemModel item;
  _HistoryItem({required this.item});

  late final _statusInfo = getHistoryStatusInfo(item.status);

  Color get _statusColor => _statusInfo.color;

  IconData get _statusIcon => _statusInfo.icon;

  String get _statusLabel => _statusInfo.label;

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final itemDay = DateTime(dt.year, dt.month, dt.day);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');

      if (itemDay == today) return 'Today, $h:$m';
      if (itemDay == today.subtract(const Duration(days: 1))) {
        return 'Yesterday, $h:$m';
      }
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]}, $h:$m';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ─── Status icon ──────────────────────────────────────────
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 22),
          ),

          const SizedBox(width: 12),

          // ─── Info ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // name + amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff1A1A2E),
                      ),
                    ),
                    if (item.cashAmount != null)
                      Text(
                        '${item.cashAmount} SYP',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: _statusColor,
                        ),
                      )
                    else
                      const Text(
                        'Prepaid',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // shop + order id
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.store_rounded,
                          size: 12,
                          color: Color(0xff9E9E9E),
                        ),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 110,
                          child: Text(
                            item.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xff9E9E9E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '#${item.id}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xffBDBDBD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // date + status badge
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: Color(0xffBDBDBD),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      _formatDate(item.createdAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xffBDBDBD),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
