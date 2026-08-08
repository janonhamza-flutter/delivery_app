import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/error_handler.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../data/models/history_model.dart';
import '../../data/repositories/history_repository.dart';

class HistoryController extends GetxController {
  HistoryController(this.repository);

  final HistoryRepository repository;

  // ── State ──────────────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isPaginating = false.obs;
  final isHistoryPageLoading = false.obs;

  final items = <HistoryItemModel>[].obs;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _refreshOnNextOpen = false;

  // ── Scroll controller for infinite scroll ──────────────────────────────────
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // ── Initial / refresh load ─────────────────────────────────────────────────
  Future<void> fetchHistory({bool fetchAllPages = false}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      _currentPage = 1;
      _hasMore = true;

      final response = await repository.getHistory(page: 1);
      var paginated = HistoryPaginatedModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );

      items.assignAll(paginated.items);
      _currentPage = paginated.currentPage;
      _hasMore = paginated.hasMore;

      if (fetchAllPages) {
        while (_hasMore) {
          final nextPage = _currentPage + 1;
          final nextResponse = await repository.getHistory(page: nextPage);
          paginated = HistoryPaginatedModel.fromJson(
            Map<String, dynamic>.from(nextResponse.data as Map),
          );

          items.addAll(paginated.items);
          _currentPage = paginated.currentPage;
          _hasMore = paginated.hasMore;
        }
      }
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void scheduleHistoryRefreshOnOpen() {
    _refreshOnNextOpen = true;
    isHistoryPageLoading.value = true;
  }

  Future<void> refreshHistoryIfScheduled() async {
    if (!_refreshOnNextOpen) return;
    _refreshOnNextOpen = false;

    try {
      await fetchHistory(fetchAllPages: true);
    } finally {
      isHistoryPageLoading.value = false;
    }
  }

  // ── Load next page ─────────────────────────────────────────────────────────
  Future<void> _loadMore() async {
    if (isPaginating.value || !_hasMore) return;

    try {
      isPaginating.value = true;
      final nextPage = _currentPage + 1;

      final response = await repository.getHistory(page: nextPage);
      final paginated = HistoryPaginatedModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );

      items.addAll(paginated.items);
      _currentPage = paginated.currentPage;
      _hasMore = paginated.hasMore;
    } on DioException catch (e) {
      AppSnackbar.error(ErrorHandler.getMessage(e));
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isPaginating.value = false;
    }
  }

  // ── Infinite scroll trigger ────────────────────────────────────────────────
  void _onScroll() {
    final threshold = scrollController.position.maxScrollExtent * 0.85;
    if (scrollController.offset >= threshold) {
      _loadMore();
    }
  }
}
