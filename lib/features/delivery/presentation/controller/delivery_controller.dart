import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/features/orders/data/repositories/order_repository.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/app_snackbar.dart';

class ActiveDeliveryController extends GetxController {
  ActiveDeliveryController(this.repository);

  final OrdersRepository repository;

  final isLoading = false.obs;

  Future<void> confirmDelivery({
    required int orderId,
    required String confirmationCode,
  }) async {
    try {
      final response = await repository.confirmDelivery(
        orderId: orderId,
        confirmationCode: confirmationCode,
      );

      AppSnackbar.success(response.data["message"]);

      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> openGoogleMaps({
    required double? latitude,
    required double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      Get.snackbar("Location", "No location available");
      return;
    }

    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
