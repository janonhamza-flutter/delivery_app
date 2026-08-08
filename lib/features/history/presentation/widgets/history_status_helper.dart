import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HistoryStatusInfo {
  const HistoryStatusInfo({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

HistoryStatusInfo getHistoryStatusInfo(String status) {
  switch (status) {
    case 'accepted':
      return const HistoryStatusInfo(
        label: 'Accepted',
        color: AppColors.info,
        icon: Icons.check_circle_outline_rounded,
      );
    case 'on_the_way':
      return const HistoryStatusInfo(
        label: 'On The Way',
        color: AppColors.warning,
        icon: Icons.delivery_dining_rounded,
      );
    case 'arrived':
      return const HistoryStatusInfo(
        label: 'Arrived',
        color: AppColors.primary,
        icon: Icons.location_on_rounded,
      );
    case 'delivered':
      return const HistoryStatusInfo(
        label: 'Delivered',
        color: AppColors.success,
        icon: Icons.done_all_rounded,
      );
    case 'cancelled':
    case 'canceled':
      return const HistoryStatusInfo(
        label: 'Cancelled',
        color: AppColors.error,
        icon: Icons.cancel_rounded,
      );
    default:
      return HistoryStatusInfo(
        label: status.isEmpty ? 'Unknown' : status.replaceAll('_', ' '),
        color: AppColors.info,
        icon: Icons.help_outline_rounded,
      );
  }
}
