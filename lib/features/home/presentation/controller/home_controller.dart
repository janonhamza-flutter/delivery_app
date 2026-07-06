import 'package:get/get.dart';

import '../../data/repositories/home_repository.dart';

class HomeController extends GetxController {
  HomeController(this.homeRepository);

  final HomeRepository homeRepository;
}
