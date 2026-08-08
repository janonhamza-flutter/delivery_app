import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/error_handler.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/models/earnings_model.dart';
import '../../data/repositories/home_repository.dart';

class HomeController extends GetxController {
  HomeController(this.homeRepository);

  final HomeRepository homeRepository;
 
  // ── State ──────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final Rx<EarningsModel?> earnings = Rx<EarningsModel?>(null);


  // ── Derived helpers (safe getters) ────────────────────────────────────────
  int get totalDeliveries => earnings.value?.totalDeliveries ?? 0;
  double get totalCash => earnings.value?.totalCash ?? 0;
  int get completedCount => earnings.value?.deliveries.length ?? 0;

  @override
  void onInit() {
    super.onInit();
    fetchEarnings();
  }

  // ── Fetch ──────────────────────────────────────────────────────────────────
  Future<void> fetchEarnings() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      final response = await homeRepository.getEarnings();
      debugPrint('Earnings API response: ${response.data}');
      earnings.value = EarningsModel.fromJson(response.data);
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
      earnings.value = EarningsModel.empty();
    } catch (e) {
      AppSnackbar.error(e.toString());
      earnings.value = EarningsModel.empty();
    } finally {
      isLoading.value = false;
    }
  }

  
  
}
