import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../delivery/presentation/pages/active_delivery_tab_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../profile/presentaion/pages/profile_page.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  // Tracks which tabs have been visited, so IndexedStack only builds a tab's
  // page (and triggers its controller's onInit API call) once the user
  // actually opens it, instead of firing all four tabs' initial fetches
  // concurrently on app start.
  final RxSet<int> visitedIndices = <int>{0}.obs;

  void changePage(int index) {
    currentIndex.value = index;
    visitedIndices.add(index);
  }

  // index 0 → Home
  // index 1 → Orders (pending requests)
  // index 2 → Active Delivery
  // index 3 → Profile
  final List<Widget> pages = [
    HomePage(),
    OrdersPage(),
    const ActiveDeliveryTabPage(),
    ProfilePage(),
  ];
}
