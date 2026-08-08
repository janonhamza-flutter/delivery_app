import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../orders/data/models/order_model.dart';
import '../controller/delivery_controller.dart';
import '../widgets/delivery_actions.dart';

class ActiveDeliveryPage extends GetView<ActiveDeliveryController> {
  ActiveDeliveryPage({super.key});

  final OrderModel order = Get.arguments as OrderModel;

  // ─── helpers ────────────────────────────────────────────────────────────────

  _StatusConfig get _statusConfig {
    switch (order.status) {
      case 'accepted':
        return _StatusConfig(
          color: AppColors.info,
          icon: Icons.check_circle_rounded,
          label: 'Accepted',
          subtitle: 'Head to the pickup location',
        );
      case 'on_the_way':
        return _StatusConfig(
          color: const Color(0xff8B5CF6),
          icon: Icons.directions_bike_rounded,
          label: 'On The Way',
          subtitle: 'Delivering to the customer',
        );
      case 'arrived':
        return _StatusConfig(
          color: AppColors.warning,
          icon: Icons.location_on_rounded,
          label: 'Arrived',
          subtitle: 'You have arrived at the destination',
        );
      case 'delivered':
        return _StatusConfig(
          color: AppColors.success,
          icon: Icons.done_all_rounded,
          label: 'Delivered',
          subtitle: 'Delivery completed successfully',
        );
      default:
        return _StatusConfig(
          color: AppColors.grey,
          icon: Icons.hourglass_top_rounded,
          label: order.status,
          subtitle: '',
        );
    }
  }

  IconData get _typeIcon {
    switch (order.type) {
      case 'device_pickup':
        return Icons.phone_iphone_rounded;
      case 'accessory_delivery':
        return Icons.headphones_rounded;
      case 'maintenance_delivery':
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
        return 'Accessory Delivery';
      case 'maintenance_delivery':
        return 'Maintenance Delivery';
      default:
        return order.type.replaceAll('_', ' ').capitalizeFirst ?? order.type;
    }
  }

  Future<void> _callCustomer() async {
    final Uri uri = Uri(scheme: 'tel', path: order.customerPhone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openMaps() async {
    if (order.latitude == null || order.longitude == null) return;
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${order.latitude},${order.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ─── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cfg = _statusConfig;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            title: const Text(
              'Active Delivery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _DeliveryHeroHeader(
                orderId: order.id,
                typeIcon: _typeIcon,
                typeLabel: _typeLabel,
                statusConfig: cfg,
              ),
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.padding,
                20,
                AppSizes.padding,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status progress tracker
                  _StatusTracker(currentStatus: order.status),

                  const SizedBox(height: 24),

                  // Customer card
                  _SectionLabel(label: 'Customer'),
                  const SizedBox(height: 10),
                  _CustomerCard(order: order, onCall: _callCustomer),

                  const SizedBox(height: 20),

                  // Location card
                  _SectionLabel(label: 'Pickup Location'),
                  const SizedBox(height: 10),
                  _LocationCard(order: order, onOpenMap: _openMaps),

                  const SizedBox(height: 20),

                  // Payment card
                  _SectionLabel(label: 'Payment'),
                  const SizedBox(height: 10),
                  _PaymentCard(order: order),

                  const SizedBox(height: 32),

                  // Action buttons
                  DeliveryActions(order: order),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status config data class
// ─────────────────────────────────────────────────────────────────────────────

class _StatusConfig {
  final Color color;
  final IconData icon;
  final String label;
  final String subtitle;
  const _StatusConfig({
    required this.color,
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Header
// ─────────────────────────────────────────────────────────────────────────────

class _DeliveryHeroHeader extends StatelessWidget {
  const _DeliveryHeroHeader({
    required this.orderId,
    required this.typeIcon,
    required this.typeLabel,
    required this.statusConfig,
  });

  final int orderId;
  final IconData typeIcon;
  final String typeLabel;
  final _StatusConfig statusConfig;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0B2C6A), Color(0xff1A4A9F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Top row: icon + request # + status badge
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(typeIcon, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Request #$orderId',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: statusConfig.color.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: statusConfig.color.withOpacity(0.55),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              statusConfig.icon,
                              color: statusConfig.color,
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              statusConfig.label.toUpperCase(),
                              style: TextStyle(
                                color: statusConfig.color,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Type label
                  Text(
                    typeLabel,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status progress tracker
// ─────────────────────────────────────────────────────────────────────────────

class _StatusTracker extends StatelessWidget {
  const _StatusTracker({required this.currentStatus});
  final String currentStatus;

  static const _steps = [
    _Step('accepted', 'Accepted', Icons.check_circle_rounded),
    _Step('on_the_way', 'On The Way', Icons.directions_bike_rounded),
    _Step('arrived', 'Arrived', Icons.location_on_rounded),
    _Step('delivered', 'Delivered', Icons.done_all_rounded),
  ];

  int get _currentIndex => _steps.indexWhere((s) => s.status == currentStatus);

  @override
  Widget build(BuildContext context) {
    final activeIdx = _currentIndex;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // connector line
            final lineActive = i ~/ 2 < activeIdx;
            return Expanded(
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: lineActive ? AppColors.primary : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          final stepIdx = i ~/ 2;
          final step = _steps[stepIdx];
          final isDone = stepIdx < activeIdx;
          final isActive = stepIdx == activeIdx;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDone || isActive
                      ? AppColors.primary
                      : AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.icon,
                  size: 18,
                  color: isDone || isActive ? Colors.white : AppColors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                step.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.grey,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Step {
  final String status;
  final String label;
  final IconData icon;
  const _Step(this.status, this.label, this.icon);
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.title),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Customer card
// ─────────────────────────────────────────────────────────────────────────────

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.order, required this.onCall});
  final OrderModel order;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0B2C6A), Color(0xff1A4A9F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.customerPhone,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onCall,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: const Icon(
                  Icons.call_rounded,
                  color: AppColors.success,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Location card
// ─────────────────────────────────────────────────────────────────────────────

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.order, required this.onOpenMap});
  final OrderModel order;
  final VoidCallback onOpenMap;

  bool get _hasLocation => order.latitude != null && order.longitude != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.store_rounded,
                    color: AppColors.error,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.shopName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      if (order.shopAddress.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.grey,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                order.shopAddress,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkGrey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.lightGrey),
          InkWell(
            onTap: _hasLocation ? onOpenMap : null,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.cardRadius),
              bottomRight: Radius.circular(AppSizes.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_rounded,
                    size: 18,
                    color: _hasLocation ? AppColors.primary : AppColors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Open in Google Maps',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _hasLocation ? AppColors.primary : AppColors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: _hasLocation ? AppColors.primary : AppColors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment card
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final bool isCash = order.paymentMethod == 'cash_on_delivery';
    final Color payColor = isCash ? AppColors.success : AppColors.info;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: payColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                isCash ? Icons.payments_rounded : Icons.credit_card_rounded,
                color: payColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCash ? 'Cash on Delivery' : 'Prepaid',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: payColor,
                    ),
                  ),
                ],
              ),
            ),
            // Cash collected badge
            if (isCash)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: order.cashCollected
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      order.cashCollected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: order.cashCollected
                          ? AppColors.success
                          : AppColors.warning,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      order.cashCollected ? 'Collected' : 'Pending',
                      style: TextStyle(
                        color: order.cashCollected
                            ? AppColors.success
                            : AppColors.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
