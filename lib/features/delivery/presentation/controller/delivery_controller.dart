import 'dart:io';

import 'package:dio/dio.dart';
import 'package:delivery_app/core/route/app_routes.dart';
import 'package:delivery_app/features/history/presentation/controller/history_controller.dart';
import 'package:delivery_app/features/orders/data/models/order_model.dart';
import 'package:delivery_app/features/orders/data/repositories/order_repository.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/error_handler.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_snackbar.dart';

class ActiveDeliveryController extends GetxController {
  ActiveDeliveryController(this.repository);

  final OrdersRepository repository;

  final isLoading = false.obs;
  final isActionLoading = false.obs;

  /// The currently active order — null means no active delivery.
  final Rx<OrderModel?> activeOrder = Rx<OrderModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchActiveOrder();
  }

  // ── Fetch active order ─────────────────────────────────────────────────────

  Future<void> fetchActiveOrder() async {
    final int? id = StorageService.getActiveOrderId();
    if (id == null) {
      activeOrder.value = null;
      return;
    }

    try {
      isLoading.value = true;
      final response = await repository.getRequestDetails(id: id);
      final data = response.data["data"] as Map<String, dynamic>;
      final order = OrderModel.fromJson(data);

      // Clear only if truly done (delivered with cash already collected, or non-cash)
      final needsCash =
          order.paymentMethod == 'cash_on_delivery' &&
          !order.cashCollected &&
          order.status == 'delivered';

      final isActive = [
        'accepted',
        'on_the_way',
        'arrived',
      ].contains(order.status);

      if (!isActive && !needsCash) {
        StorageService.clearActiveOrderId();
        activeOrder.value = null;
      } else {
        activeOrder.value = order;
      }
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
      activeOrder.value = null;
    } catch (e) {
      AppSnackbar.error(e.toString());
      activeOrder.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // ── Status update: accepted→on_the_way OR on_the_way→arrived ──────────────

  Future<void> updateStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      isActionLoading.value = true;
      final response = await repository.updateStatus(
        orderId: orderId,
        status: status,
      );
      AppSnackbar.success(response.data["message"]);

      // Refresh to reflect the new status
      await fetchActiveOrder();
      await Get.find<HistoryController>().fetchHistory();
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  // ── Complete delivery ──────────────────────────────────────────────────────

  Future<void> confirmDelivery({
    required int orderId,
    String? confirmationCode,
    File? image,
  }) async {
    final hasCode =
        confirmationCode != null && confirmationCode.trim().isNotEmpty;
    final hasImage = image != null;

    if (!hasCode && !hasImage) {
      AppSnackbar.error('deliveryActions.confirmationRequired'.tr);
      return;
    }

    try {
      isLoading.value = true;
      final response = await repository.confirmDelivery(
        orderId: orderId,
        confirmationCode: hasCode ? confirmationCode.trim() : null,
        image: image,
      );
      AppSnackbar.success(response.data["message"]);

      // Build updated order from current data + response fields
      // (confirm response is partial — only id, status, cash_collected, etc.)
      final current = activeOrder.value;
      if (current == null) return;

      final responseData = response.data["data"] as Map<String, dynamic>;
      final deliveredOrder = OrderModel(
        id: current.id,
        type: current.type,
        status: responseData["status"] ?? "delivered",
        paymentMethod: current.paymentMethod,
        cashCollected: responseData["cash_collected"] ?? current.cashCollected,
        confirmedAt: responseData["confirmed_at"],
        deliveryWorkerId: current.deliveryWorkerId,
        customerId: current.customerId,
        shopId: current.shopId,
        customerName: current.customerName,
        customerPhone: current.customerPhone,
        shopName: current.shopName,
        shopAddress: current.shopAddress,
        maintenanceTrackingNumber: current.maintenanceTrackingNumber,
        maintenanceDeviceModel: current.maintenanceDeviceModel,
        maintenanceStatus: current.maintenanceStatus,
        latitude: current.latitude,
        longitude: current.longitude,
      );

      activeOrder.value = deliveredOrder;
      await Get.find<HistoryController>().fetchHistory();

      // If no cash to collect → done
      final needsCash =
          deliveredOrder.paymentMethod == 'cash_on_delivery' &&
          !deliveredOrder.cashCollected;

      if (!needsCash) {
        StorageService.clearActiveOrderId();
        activeOrder.value = null;
        Get.offAllNamed(AppRoutes.main);
      }
      // else: stay on Active tab — _CollectCashCard will appear
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Collect cash ───────────────────────────────────────────────────────────

  Future<void> collectCash({
    required int orderId,
    required double cashAmount,
  }) async {
    try {
      isActionLoading.value = true;
      final response = await repository.collectCash(
        orderId: orderId,
        cashAmount: cashAmount,
      );
      AppSnackbar.success(response.data["message"]);

      // All done — clear and go home
      await Get.find<HistoryController>().fetchHistory();
      StorageService.clearActiveOrderId();
      activeOrder.value = null;
      Get.offAllNamed(AppRoutes.main);
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  /// Internal: refresh activeOrder from API without clearing storage.
  Future<void> refreshActiveOrder(int id) async {
    try {
      final response = await repository.getRequestDetails(id: id);
      final data = response.data["data"] as Map<String, dynamic>;
      activeOrder.value = OrderModel.fromJson(data);
    } catch (_) {}
  }

  // ── Reject / release back to queue ─────────────────────────────────────────

  Future<void> rejectOrder({required int orderId}) async {
    try {
      isActionLoading.value = true;
      final response = await repository.rejectOrder(orderId: orderId);
      AppSnackbar.success(response.data["message"]);

      // Clear stored id — no longer active
      await Get.find<HistoryController>().fetchHistory();
      StorageService.clearActiveOrderId();
      activeOrder.value = null;

      Get.offAllNamed(AppRoutes.main);
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  // ── Open maps ──────────────────────────────────────────────────────────────

  Future<void> openGoogleMaps({
    required double? latitude,
    required double? longitude,
  }) async {
    if (latitude == null || longitude == null) {
      AppSnackbar.error('deliveryActions.noLocationAvailable'.tr);
      return;
    }
    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
