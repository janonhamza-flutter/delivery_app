import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/home_controller.dart';
import '../widgets/home_header.dart';
import '../widgets/order_card.dart';
import '../widgets/welcome_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),

          child: Column(
            children: [
              /// Header
              const HomeHeader(),

              const SizedBox(height: 25),

              /// Welcome
              const WelcomeCard(),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Today's Deliveries",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: 6,

                  itemBuilder: (_, index) {
                    return const OrderCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
