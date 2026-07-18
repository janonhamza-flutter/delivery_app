import 'package:get/get.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../profile/presentaion/pages/profile_page.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  final pages = [HomePage(), OrdersPage(), ProfilePage()];
}
