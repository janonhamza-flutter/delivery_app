import 'package:get/get.dart';

import '../data/repositories/profile_repository.dart';
import '../presentaion/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileRepository(Get.find()));

    Get.lazyPut(() => ProfileController(Get.find()));
  }
}
