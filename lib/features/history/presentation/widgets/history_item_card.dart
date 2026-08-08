import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/history_model.dart';
import 'history_status_helper.dart';

class HistoryItemCard extends StatelessWidget {
  final HistoryItemModel item;
   HistoryItemCard({super.key, required this.item});

  late final _statusInfo = getHistoryStatusInfo(item.status);

  Color get _statusColor => _statusInfo.color;

  IconData get _statusIcon => _statusInfo.icon;

  String get _statusLabel => _statusInfo.label;

  String get _typeLabel {
    switch (item.type) {
      case 'device_pickup':
        return 'Device Pickup';
      case 'accessory_delivery':
        return 'Accessory';
      case 'maintenance_return':
        return 'Maintenance Return';
      default:
        return _capitalize(item.type.replaceAll('_', ' '));
    }
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
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
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]}, $h:$m';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Status Icon ─────────────────────────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 24),
          ),

          const SizedBox(width: 14),

          // ─── Content ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xff1A1A2E),
                      ),
                    ),
                    _StatusBadge(label: _statusLabel, color: _statusColor),
                  ],
                ),

                const SizedBox(height: 6),

                // type + shop
                Row(
                  children: [
                    _Chip(
                      icon: Icons.category_rounded,
                      label: _typeLabel,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 8),
                    _Chip(
                      icon: Icons.store_rounded,
                      label: item.shopName,
                      color: AppColors.primary,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // bottom row: date + cash
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: Color(0xffAAAAAA),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(item.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xffAAAAAA),
                          ),
                        ),
                      ],
                    ),

                    // cash amount (only for cash_on_delivery)
                    if (item.cashAmount != null)
                      Row(
                        children: [
                          Icon(
                            item.cashCollected
                                ? Icons.payments_rounded
                                : Icons.money_off_rounded,
                            size: 14,
                            color: item.cashCollected
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.cashAmount} SYP',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: item.cashCollected
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),

                    // order id
                    Text(
                      '#${item.id}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xffCCCCCC),
                        fontWeight: FontWeight.w500,
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

// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
