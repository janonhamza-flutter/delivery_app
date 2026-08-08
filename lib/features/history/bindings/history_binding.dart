import 'package:get/get.dart';

import '../data/repositories/history_repository.dart';
import '../presentation/controller/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // Use fenix so GetX reuses the existing instance registered in MainBinding
    // when navigating from the Home tab, and creates a fresh one otherwise.
    Get.lazyPut(() => HistoryRepository(Get.find()), fenix: true);
    Get.lazyPut(() => HistoryController(Get.find()), fenix: true);
  }
}
