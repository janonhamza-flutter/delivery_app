import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: controller.pages,
        ),
        bottomNavigationBar: const CustomBottomNavBar(),
      ),
    );
  }
}
