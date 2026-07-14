import 'package:get/get.dart';

import '../services/dio_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioService(), permanent: true);
  }
}
