import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      return HistoryStatusInfo(
        label: 'status.accepted'.tr,
        color: AppColors.info,
        icon: Icons.check_circle_outline_rounded,
      );
    case 'on_the_way':
      return HistoryStatusInfo(
        label: 'status.onTheWay'.tr,
        color: AppColors.warning,
        icon: Icons.delivery_dining_rounded,
      );
    case 'arrived':
      return HistoryStatusInfo(
        label: 'status.arrived'.tr,
        color: AppColors.primary,
        icon: Icons.location_on_rounded,
      );
    case 'delivered':
      return HistoryStatusInfo(
        label: 'status.delivered'.tr,
        color: AppColors.success,
        icon: Icons.done_all_rounded,
      );
    case 'cancelled':
    case 'canceled':
      return HistoryStatusInfo(
        label: 'status.cancelled'.tr,
        color: AppColors.error,
        icon: Icons.cancel_rounded,
      );
    default:
      return HistoryStatusInfo(
        label: status.isEmpty ? 'status.unknown'.tr : status.replaceAll('_', ' '),
        color: AppColors.info,
        icon: Icons.help_outline_rounded,
      );
  }
}
