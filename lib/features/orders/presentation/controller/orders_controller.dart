import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/error_handler.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../delivery/presentation/controller/delivery_controller.dart';
import '../../../main/presentation/controller/main_controller.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

Map<String, dynamic> _normalizePayload(dynamic value) {
  if (value is String) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

/// Extracts the order list plus Laravel-style pagination metadata
/// (current_page/per_page/total) from an orders API payload, whether the
/// payload is a bare list or the standard `{data: {current_page, ..., data: [...]}}`
/// paginator shape.
class _OrdersPage {
  _OrdersPage(this.items, this.currentPage, this.hasMore);

  final List<dynamic> items;
  final int currentPage;
  final bool hasMore;
}

_OrdersPage _parseOrdersPage(dynamic rawResponse, {required int requestedPage}) {
  final payload = _normalizePayload(rawResponse);
  final dynamic rawData = payload["data"] ?? payload;

  if (rawData is List) {
    // No pagination metadata available — treat as a single, complete page.
    return _OrdersPage(rawData, requestedPage, false);
  }

  if (rawData is Map) {
    final data = Map<String, dynamic>.from(rawData);
    final List<dynamic> list = data["data"] is List
        ? List<dynamic>.from(data["data"] as List)
        : (data["data"] is Map ? [data["data"]] : <dynamic>[]);

    final currentPage = _parseInt(data["current_page"]) ?? requestedPage;
    final perPage = _parseInt(data["per_page"]) ?? 0;
    final total = _parseInt(data["total"]) ?? 0;
    final hasMore = perPage > 0 && currentPage * perPage < total;

    return _OrdersPage(list, currentPage, hasMore);
  }

  return _OrdersPage(<dynamic>[], requestedPage, false);
}

bool shouldShowInRequests(OrderModel order) {
  if (order.type != 'device_pickup') {
    return true;
  }

  // Picking the device up from the customer (before repair) has no
  // completion requirement — only returning it after repair does.
  if (order.direction != 'shop_to_customer') {
    return true;
  }

  final maintenanceCustomerStatus = order.maintenanceCustomerStatus
      ?.trim()
      .toLowerCase();
  return maintenanceCustomerStatus == 'completed';
}

class OrdersController extends GetxController {
  OrdersController(this.repository);

  final OrdersRepository repository;

  final isLoading = false.obs;
  final isPaginating = false.obs;
  final isActionLoading = false.obs;

  final orders = <OrderModel>[].obs;
  final scrollController = ScrollController();

  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    getOrders();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  // ── Initial / refresh ──────────────────────────────────────────────────────
  Future<void> getOrders() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      _currentPage = 1;
      _hasMore = true;

      final response = await repository.getOrders(page: 1);
      final page = _parseOrdersPage(response.data, requestedPage: 1);

      orders.clear();
      for (final item in page.items) {
        if (item is Map) {
          final order = OrderModel.fromJson(Map<String, dynamic>.from(item));
          if (shouldShowInRequests(order)) {
            orders.add(order);
          }
        }
      }

      _currentPage = page.currentPage;
      _hasMore = page.hasMore;
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Load next page ─────────────────────────────────────────────────────────
  Future<void> _loadMore() async {
    if (isPaginating.value || !_hasMore) return;
    try {
      isPaginating.value = true;
      final nextPage = _currentPage + 1;
      final response = await repository.getOrders(page: nextPage);
      final page = _parseOrdersPage(response.data, requestedPage: nextPage);

      for (final item in page.items) {
        if (item is Map) {
          final order = OrderModel.fromJson(Map<String, dynamic>.from(item));
          if (shouldShowInRequests(order)) {
            orders.add(order);
          }
        }
      }

      _currentPage = page.currentPage;
      _hasMore = page.hasMore;
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isPaginating.value = false;
    }
  }

  void _onScroll() {
    final threshold = scrollController.position.maxScrollExtent * 0.85;
    if (scrollController.offset >= threshold) _loadMore();
  }

  // ── Accept ─────────────────────────────────────────────────────────────────
  Future<void> acceptOrder({
    required OrderModel order,
    required String estimatedTime,
  }) async {
    try {
      isActionLoading.value = true;
      final response = await repository.acceptOrder(
        orderId: order.id,
        estimatedTime: estimatedTime,
      );
      AppSnackbar.success(response.data["message"]);

      StorageService.saveActiveOrderId(order.id);

      // OrderDetailsPage sits on top of the already-loaded Main page — pop
      // back to it instead of destroying and rebuilding it, which would
      // refire every tab's initial fetch (earnings, history, profile...) at
      // once. Only refresh what actually changed: the pending list (this
      // order is no longer pending) and the newly accepted active order.
      Get.until((route) => route.settings.name == AppRoutes.main);
      Get.find<MainController>().changePage(2);
      unawaited(getOrders());
      unawaited(Get.find<ActiveDeliveryController>().fetchActiveOrder());
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  // ── Reject ─────────────────────────────────────────────────────────────────
  Future<void> rejectOrder({required int orderId, String? reason}) async {
    try {
      isActionLoading.value = true;
      final response = await repository.rejectOrder(
        orderId: orderId,
        reason: reason,
      );
      AppSnackbar.success(response.data["message"]);

      // OrderDetailsPage sits on top of the already-loaded Main page — pop
      // back to it instead of destroying and rebuilding it, then jump to the
      // Home tab.
      Get.until((route) => route.settings.name == AppRoutes.main);
      Get.find<MainController>().changePage(0);
      unawaited(getOrders());
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  // ── Confirm delivery ───────────────────────────────────────────────────────
  Future<void> confirmDelivery({
    required int orderId,
    String? confirmationCode,
    File? image,
  }) async {
    try {
      isActionLoading.value = true;
      final response = await repository.confirmDelivery(
        orderId: orderId,
        confirmationCode: confirmationCode,
        image: image,
      );
      AppSnackbar.success(response.data["message"]);
      await getOrders();
      Get.offAllNamed(AppRoutes.main);
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }
}
