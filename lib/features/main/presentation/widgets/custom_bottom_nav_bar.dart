import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../delivery/presentation/controller/delivery_controller.dart';
import '../controller/main_controller.dart';

class CustomBottomNavBar extends GetView<MainController> {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryCtrl = Get.find<ActiveDeliveryController>();

    return Obx(() {
      final hasActive = deliveryCtrl.activeOrder.value != null;

      return BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: 'nav.home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inbox_rounded),
            label: 'nav.requests'.tr,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.directions_bike_rounded),
                if (hasActive)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'profile.active'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: 'nav.profile'.tr,
          ),
        ],
      );
    });
  }
}
