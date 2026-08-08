import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/error_handler.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_snackbar.dart';
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

bool shouldShowInRequests(OrderModel order) {
  if (order.type != 'device_pickup') {
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
      debugPrint('Orders API response: ${response.data}');
      final dynamic rawResponse = response.data;
      final Map<String, dynamic> payload = _normalizePayload(rawResponse);
      final dynamic rawData = payload["data"] ?? payload;
      final List<dynamic> list = (() {
        if (rawData is List) {
          return rawData;
        }
        if (rawData is Map) {
          final data = Map<String, dynamic>.from(rawData);
          if (data["data"] is List) {
            return List<dynamic>.from(data["data"] as List);
          }
          if (data["data"] is Map) {
            return [data["data"]];
          }
        }
        return <dynamic>[];
      })();

      orders.clear();
      for (final item in list) {
        if (item is Map) {
          final order = OrderModel.fromJson(Map<String, dynamic>.from(item));
          if (shouldShowInRequests(order)) {
            orders.add(order);
          }
        }
      }

      _currentPage = 1;
      _hasMore = false;
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
      debugPrint('Orders API response page $nextPage: ${response.data}');
      final dynamic rawResponse = response.data;
      final Map<String, dynamic> payload = _normalizePayload(rawResponse);
      final dynamic rawData = payload["data"] ?? payload;
      final List<dynamic> list = (() {
        if (rawData is List) {
          return rawData;
        }
        if (rawData is Map) {
          final data = Map<String, dynamic>.from(rawData);
          if (data["data"] is List) {
            return List<dynamic>.from(data["data"] as List);
          }
          if (data["data"] is Map) {
            return [data["data"]];
          }
        }
        return <dynamic>[];
      })();

      for (final item in list) {
        if (item is Map) {
          final order = OrderModel.fromJson(Map<String, dynamic>.from(item));
          if (shouldShowInRequests(order)) {
            orders.add(order);
          }
        }
      }

      _currentPage = nextPage;
      _hasMore = false;
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
      Get.offAllNamed(AppRoutes.main);
      await Future.delayed(const Duration(milliseconds: 150));
      Get.find<MainController>().changePage(2);
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  // ── Reject ─────────────────────────────────────────────────────────────────
  Future<void> rejectOrder({required int orderId}) async {
    try {
      isActionLoading.value = true;
      final response = await repository.rejectOrder(orderId: orderId);
      AppSnackbar.success(response.data["message"]);
      await getOrders();
      Get.back();
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
