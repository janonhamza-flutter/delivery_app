import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.primary,

        borderRadius: BorderRadius.circular(20),
      ),

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "Good Morning 👋",

            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "You have 6 deliveries today",

            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
