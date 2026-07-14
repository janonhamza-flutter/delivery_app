import 'package:get/get.dart';

import '../../data/repositories/delivery_repository.dart';

class ActiveDeliveryController extends GetxController {
  ActiveDeliveryController(this.repository);

  final ActiveDeliveryRepository repository;

  final isLoading = false.obs;
}
