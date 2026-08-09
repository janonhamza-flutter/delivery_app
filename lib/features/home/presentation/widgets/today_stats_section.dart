import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/home_controller.dart';

class TodayStatsSection extends GetView<HomeController> {
  const TodayStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const _LoadingSkeleton();
      }

      final e = controller.earnings.value;
      final totalDeliveries = e?.totalDeliveries ?? 0;
      final totalCash = e?.totalCash ?? 0.0;
      final completed = e?.deliveries.length ?? 0;

      return Column(
        children: [
          // ─── Main Earnings Card ──────────────────────────────────────
          _EarningsCard(
            totalCash: totalCash,
            completed: completed,
            totalDeliveries: totalDeliveries,
          ),

          const SizedBox(height: 14),

          // ─── Stats Row ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _StatMiniCard(
                  icon: Icons.local_shipping_rounded,
                  iconColor: AppColors.info,
                  iconBg: AppColors.info.withValues(alpha: 0.12),
                  label: 'home.deliveriesLabel'.tr,
                  value: '$totalDeliveries',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatMiniCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: AppColors.success,
                  iconBg: AppColors.success.withValues(alpha: 0.12),
                  label: 'home.completed'.tr,
                  value: '$completed',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatMiniCard(
                  icon: Icons.payments_rounded,
                  iconColor: AppColors.warning,
                  iconBg: AppColors.warning.withValues(alpha: 0.12),
                  label: 'home.cash'.tr,
                  value: _formatCash(totalCash),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  String _formatCash(double v) {
    if (v >= 1000000) {
      final value = (v / 1000000);
      return '${value.toStringAsFixed(1)}M';
    }
    if (v >= 1000) {
      final value = (v / 1000);
      return '${value.toStringAsFixed(1)}K';
    }
    return v.toStringAsFixed(2);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Earnings Card
// ─────────────────────────────────────────────────────────────────────────────
class _EarningsCard extends StatelessWidget {
  final double totalCash;
  final int completed;
  final int totalDeliveries;

  const _EarningsCard({
    required this.totalCash,
    required this.completed,
    required this.totalDeliveries,
  });

  String get _formattedCash {
    return totalCash % 1 == 0
        ? totalCash.toInt().toString()
        : totalCash.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xff0B2C6A), Color(0xff1A4DB0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0B2C6A).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────────────────────────────
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 40,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header label
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'home.todaysEarnings'.tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // amount + progress badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "SYP ",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formattedCash,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const Spacer(),
                  _ProgressBadge(current: completed, total: totalDeliveries),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 14),

              // bottom info row
              Row(
                children: [
                  // _EarningDetail(
                  //   icon: Icons.local_shipping_rounded,
                  //   label: "Total",
                  //   value: "$totalDeliveries orders",
                  // ),
                  // const SizedBox(width: 24),
                  // _EarningDetail(
                  //   icon: Icons.check_circle_outline_rounded,
                  //   label: "Done",
                  //   value: "$completed orders",
                  // ),
                  const Spacer(),
                  // cash badge
                  if (totalCash > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.trending_up_rounded,
                            color: AppColors.success,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'profile.active'.tr,
                            style: const TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
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
// Progress Badge
// ─────────────────────────────────────────────────────────────────────────────
class _ProgressBadge extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressBadge({required this.current, required this.total});

  double get _progress => total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Text(
        //   '$current / $total',
        //   style: const TextStyle(
        //     color: Colors.white,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 15,
        //   ),
        // ),
        // const SizedBox(height: 4),
        // const Text(
        //   "Completed",
        //   style: TextStyle(color: Colors.white60, fontSize: 11),
        // ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.success,
              ),
              minHeight: 5,
            ),
          ),
        ),
      ],
    );
  }
}

// // ─────────────────────────────────────────────────────────────────────────────
// // Earning detail item
// // ─────────────────────────────────────────────────────────────────────────────
// class _EarningDetail extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   const _EarningDetail({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.white60, size: 15),
//         const SizedBox(width: 5),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(color: Colors.white54, fontSize: 10),
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// ─────────────────────────────────────────────────────────────────────────────
// Mini Stat Card
// ─────────────────────────────────────────────────────────────────────────────
class _StatMiniCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _StatMiniCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xff1A1A2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xff6B7280)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading skeleton
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Earnings card skeleton
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.grey.withValues(alpha: 0.15),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Mini cards skeleton
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(left: i == 0 ? 0 : 12),
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
