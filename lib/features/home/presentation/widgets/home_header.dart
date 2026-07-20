import 'package:delivery_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
         // backgroundImage: AssetImage(AppAssets.profile),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("Welcome 👋", style: TextStyle(color: Colors.grey)),

              Text(
                "Delivery Driver",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},

          icon: const Icon(Icons.notifications_none, color: AppColors.primary),
        ),
      ],
    );
  }
}
