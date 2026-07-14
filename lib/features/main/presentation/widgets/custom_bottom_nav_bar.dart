import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/main_controller.dart';

class CustomBottomNavBar extends GetView<MainController> {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,

        onTap: controller.changePage,

        selectedItemColor: AppColors.primary,

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_rounded),
            label: "Orders",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
