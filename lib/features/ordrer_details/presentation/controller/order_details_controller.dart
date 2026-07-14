import 'package:get/get.dart';

import '../../data/repositories/order_details_repository.dart';

class OrderDetailsController extends GetxController {
  OrderDetailsController(this.repository);

  final OrderDetailsRepository repository;

  final isLoading = false.obs;
}
