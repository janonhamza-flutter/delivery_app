import 'package:get/get.dart';

import '../../data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  OrdersController(this.ordersRepository);

  final OrdersRepository ordersRepository;

  final isLoading = false.obs;
}
