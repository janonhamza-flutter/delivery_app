import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../orders/data/models/order_model.dart';
import '../controller/order_details_controller.dart';
import '../widgets/address_card.dart';
import '../widgets/button_action.dart';
import '../widgets/customer_card.dart';
import '../widgets/device_card.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late final OrderModel order;
  late final OrderDetailsController controller;

  @override
  void initState() {
    super.initState();
    order = Get.arguments as OrderModel;
    controller = Get.find<OrderDetailsController>();
    controller.fetchRequestDetails(requestId: order.id);
  }

  // ─── helpers ────────────────────────────────────────────────────────────────

  Color _statusColorFor(OrderModel currentOrder) {
    switch (currentOrder.status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'accepted':
        return AppColors.info;
      case 'on_the_way':
        return const Color(0xff8B5CF6);
      case 'arrived':
        return Colors.deepPurple;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  IconData _statusIconFor(OrderModel currentOrder) {
    switch (currentOrder.status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'on_the_way':
        return Icons.directions_bike_rounded;
      case 'arrived':
        return Icons.location_on_rounded;
      case 'delivered':
        return Icons.done_all_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  String _statusLabelFor(OrderModel currentOrder) {
    switch (currentOrder.status.toLowerCase()) {
      case 'pending':
        return 'status.pending'.tr;
      case 'accepted':
        return 'status.accepted'.tr;
      case 'on_the_way':
        return 'status.onTheWay'.tr;
      case 'arrived':
        return 'status.arrived'.tr;
      case 'delivered':
        return 'status.delivered'.tr;
      case 'cancelled':
        return 'status.cancelled'.tr;
      default:
        return currentOrder.status.replaceAll('_', ' ').capitalizeFirst ??
            currentOrder.status;
    }
  }

  IconData _typeIconFor(OrderModel currentOrder) {
    switch (currentOrder.type) {
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

  String _typeLabelFor(OrderModel currentOrder) {
    switch (currentOrder.type) {
      case 'device_pickup':
        return 'home.typeDevicePickup'.tr;
      case 'accessory_delivery':
        return 'orderDetails.typeAccessoryDelivery'.tr;
      case 'maintenance_delivery':
        return 'orderDetails.typeMaintenanceDelivery'.tr;
      default:
        return currentOrder.type.replaceAll('_', ' ').capitalizeFirst ??
            currentOrder.type;
    }
  }

  // ─── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final displayOrder = controller.orderDetails.value ?? order;
    final isRefreshing = controller.isLoading.value;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroHeader(
                orderId: displayOrder.id,
                typeIcon: _typeIconFor(displayOrder),
                typeLabel: _typeLabelFor(displayOrder),
                statusColor: _statusColorFor(displayOrder),
                statusIcon: _statusIconFor(displayOrder),
                statusLabel: _statusLabelFor(displayOrder),
              ),
            ),
            title: Text(
              'orderDetails.title'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),

          // ── Body Content ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              // If a fresh fetch was triggered, use that data; else use passed order
              final displayOrder = controller.orderDetails.value ?? order;

              if (isRefreshing && controller.orderDetails.value == null) {
                return const SizedBox(
                  height: 320,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.padding,
                  20,
                  AppSizes.padding,
                  40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment badge + refresh
                    _PaymentBadgeRow(order: displayOrder),

                    const SizedBox(height: 24),

                    // Customer Card
                    _SectionLabel(label: 'orderDetails.customer'.tr),
                    const SizedBox(height: 10),
                    CustomerCard(order: displayOrder),

                    const SizedBox(height: 20),

                    // Address Card
                    _SectionLabel(label: 'orderDetails.deliveryLocation'.tr),
                    const SizedBox(height: 10),
                    AddressCard(order: displayOrder),

                    const SizedBox(height: 20),

                    // Order / Device info
                    _SectionLabel(label: 'orderDetails.title'.tr),
                    const SizedBox(height: 10),
                    DeviceCard(order: displayOrder),

                    // Maintenance info (only for device_pickup with maintenance data)
                    if (displayOrder.maintenanceTrackingNumber != null) ...[
                      const SizedBox(height: 20),
                      _SectionLabel(label: 'orderDetails.maintenanceInfo'.tr),
                      const SizedBox(height: 10),
                      _MaintenanceCard(order: displayOrder),
                    ],

                    const SizedBox(height: 32),

                    // Action Buttons
                    ActionButtons(order: displayOrder),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Header widget
// ─────────────────────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.orderId,
    required this.typeIcon,
    required this.typeLabel,
    required this.statusColor,
    required this.statusIcon,
    required this.statusLabel,
  });

  final int orderId;
  final IconData typeIcon;
  final String typeLabel;
  final Color statusColor;
  final IconData statusIcon;
  final String statusLabel;

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
          // Decorative circle
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
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
                color: Colors.white.withValues(alpha: 0.06),
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
                  // ── Top row: icon + Request # on left, status badge on right ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Type icon bubble
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(typeIcon, color: Colors.white, size: 26),
                      ),

                      const SizedBox(width: 12),

                      // Request #
                      Expanded(
                        child: Text(
                          'Request #$orderId',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.85),
                            letterSpacing: 0.4,
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
                          color: statusColor.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.55),
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(statusIcon, color: statusColor, size: 14),
                            const SizedBox(width: 5),
                            Text(
                              statusLabel.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
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

                  // ── Bottom: type label fills full width ──────────────────────
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
// Payment badge row
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentBadgeRow extends StatelessWidget {
  const _PaymentBadgeRow({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final bool isCash = order.paymentMethod == 'cash_on_delivery';
    final Color payColor = isCash ? AppColors.success : AppColors.info;

    return Row(
      children: [
        // Payment badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: payColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: payColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCash ? Icons.payments_rounded : Icons.credit_card_rounded,
                color: payColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                isCash ? 'orders.cashOnDelivery'.tr : 'home.prepaid'.tr,
                style: TextStyle(
                  color: payColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Cash collected indicator (if applicable)
        if (isCash)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: order.cashCollected
                  ? AppColors.success.withValues(alpha: 0.12)
                  : AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
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
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  order.cashCollected
                      ? 'orderDetails.cashCollected'.tr
                      : 'orderDetails.notCollected'.tr,
                  style: TextStyle(
                    color: order.cashCollected
                        ? AppColors.success
                        : AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Maintenance info card
// ─────────────────────────────────────────────────────────────────────────────

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({required this.order});
  final OrderModel order;

  Color get _mStatusColor {
    switch (order.maintenanceStatus?.toLowerCase()) {
      case 'approved':
        return AppColors.success;
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.confirmation_number_rounded,
              iconColor: AppColors.primary,
              label: 'orderDetails.trackingNumber'.tr,
              value: order.maintenanceTrackingNumber ?? '—',
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.phone_android_rounded,
              iconColor: AppColors.info,
              label: 'orderDetails.deviceModel'.tr,
              value: order.maintenanceDeviceModel ?? '—',
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _mStatusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.engineering_rounded,
                    color: _mStatusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'orderDetails.maintenanceStatus'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _mStatusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (order.maintenanceStatus ?? '—')
                            .replaceAll('_', ' ')
                            .capitalizeFirst!,
                        style: TextStyle(
                          color: _mStatusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info row helper
// ─────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
