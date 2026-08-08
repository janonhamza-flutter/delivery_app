import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/history_controller.dart';
import '../widgets/history_item_card.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isHistoryPageLoading.value) {
          Future.microtask(controller.refreshHistoryIfScheduled);
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ── Initial loading ─────────────────────────────────────────
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ── Empty state ─────────────────────────────────────────────
        if (controller.items.isEmpty) {
          return _EmptyState(onRefresh: controller.fetchHistory);
        }

        // ── List ────────────────────────────────────────────────────
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.fetchHistory,
          child: ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: controller.items.length + 1, // +1 for footer
            itemBuilder: (context, index) {
              // ── Summary header ──────────────────────────────────
              if (index == 0) {
                final delivered = controller.items
                    .where((e) => e.status == 'delivered')
                    .length;
                final cancelled = controller.items
                    .where(
                      (e) => e.status == 'cancelled' || e.status == 'canceled',
                    )
                    .length;

                return _SummaryHeader(
                  total: controller.items.length,
                  delivered: delivered,
                  cancelled: cancelled,
                );
              }

              final item = controller.items[index - 1];

              // ── Pagination footer ───────────────────────────────
              if (index == controller.items.length) {
                return Obx(
                  () => controller.isPaginating.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                );
              }

              return HistoryItemCard(item: item);
            },
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffF4F6FB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
      ),
      title: const Text(
        'Delivery History',
        style: TextStyle(
          color: Color(0xff1A1A2E),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary),
          tooltip: 'Filter',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary header
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryHeader extends StatelessWidget {
  final int total;
  final int delivered;
  final int cancelled;
  const _SummaryHeader({
    required this.total,
    required this.delivered,
    required this.cancelled,
  });

  @override
  Widget build(BuildContext context) {
    final rate = total == 0 ? 0.0 : delivered / total;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0B2C6A), Color(0xff1A4DB0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0B2C6A).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Total',
                value: '$total',
                icon: Icons.receipt_long_rounded,
              ),
              _Divider(),
              _StatItem(
                label: 'Delivered',
                value: '$delivered',
                icon: Icons.check_circle_rounded,
                valueColor: AppColors.success,
              ),
              _Divider(),
              _StatItem(
                label: 'Cancelled',
                value: '$cancelled',
                icon: Icons.cancel_rounded,
                valueColor: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // success rate bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Success Rate',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${(rate * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: rate,
                  minHeight: 6,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: valueColor.withValues(alpha: 0.8), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 50, color: Colors.white24);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Delivery History Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your completed deliveries will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xff6B7280)),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              label: const Text(
                'Refresh',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
