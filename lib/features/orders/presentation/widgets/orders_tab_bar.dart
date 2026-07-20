import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const TabBar(
        indicatorColor: AppColors.secondary,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: "New Requests"),
          Tab(text: "My Deliveries"),
        ],
      ),
    );
  }
}
