import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../../core/services/error_handler.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../orders/data/models/order_model.dart';
import '../../data/repositories/order_details_repository.dart';

class OrderDetailsController extends GetxController {
  OrderDetailsController(this.repository);

  final OrderDetailsRepository repository;

  final isLoading = false.obs;
  final Rx<OrderModel?> orderDetails = Rx<OrderModel?>(null);

  /// Fetch fresh data for a specific delivery request by ID.
  Future<void> fetchRequestDetails({required int requestId}) async {
    try {
      isLoading.value = true;
      final response = await repository.getRequestDetails(requestId: requestId);
      final dynamic rawResponse = response.data;
      final Map<String, dynamic> payload = rawResponse is Map
          ? Map<String, dynamic>.from(rawResponse)
          : <String, dynamic>{};
      final dynamic rawData = payload["data"] ?? payload;
      final data = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};
      orderDetails.value = OrderModel.fromJson(data);
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
