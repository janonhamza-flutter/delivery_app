import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/data/models/order_model.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key, required this.order});

  final OrderModel order;

  Future<void> _openGoogleMaps() async {
    if (order.latitude == null || order.longitude == null) {
      return;
    }
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  bool get _hasLocation => order.latitude != null && order.longitude != null;

  @override
  Widget build(BuildContext context) {
    final addressText = (order.address ?? order.shopAddress).trim();
    final hasAddress = addressText.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasAddress) ...[
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      addressText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            InkWell(
              onTap: _hasLocation ? _openGoogleMaps : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.map_rounded,
                      size: 18,
                      color: _hasLocation ? AppColors.primary : AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'orderDetails.openInMaps'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _hasLocation
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
