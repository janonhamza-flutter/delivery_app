import 'dart:convert';

Map<String, dynamic> _normalizeJsonMap(dynamic value) {
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
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

class HistoryItemModel {
  final int id;
  final String type;
  final String status;
  final String paymentMethod;
  final bool cashCollected;
  final String? cashAmount;
  final String? confirmedAt;
  final String createdAt;
  final String customerName;
  final String customerPhone;
  final String shopName;

  HistoryItemModel({
    required this.id,
    required this.type,
    required this.status,
    required this.paymentMethod,
    required this.cashCollected,
    this.cashAmount,
    this.confirmedAt,
    required this.createdAt,
    required this.customerName,
    required this.customerPhone,
    required this.shopName,
  });

  factory HistoryItemModel.fromJson(dynamic json) {
    final data = _normalizeJsonMap(json);
    final customer = _normalizeJsonMap(data['customer']);
    final shop = _normalizeJsonMap(data['shop']);

    final firstName = customer['first_name']?.toString() ?? '';
    final lastName = customer['last_name']?.toString() ?? '';
    final customerName = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(' ').trim();

    return HistoryItemModel(
      id: _parseInt(data['id']) ?? 0,
      type: data['type']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      paymentMethod: data['payment_method']?.toString() ?? '',
      cashCollected: data['cash_collected'] is bool
          ? data['cash_collected'] as bool
          : false,
      cashAmount: data['cash_amount']?.toString(),
      confirmedAt: data['confirmed_at']?.toString(),
      createdAt: data['created_at']?.toString() ?? '',
      customerName: customerName.isNotEmpty
          ? customerName
          : data['customer_name']?.toString() ?? 'Unknown',
      customerPhone: customer['phone']?.toString() ?? '',
      shopName: shop['name']?.toString() ?? 'Unknown',
    );
  }
}

class HistoryPaginatedModel {
  final int currentPage;
  final int perPage;
  final int total;
  final List<HistoryItemModel> items;

  HistoryPaginatedModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.items,
  });

  factory HistoryPaginatedModel.fromJson(dynamic json) {
    final data = _normalizeJsonMap(json);
    final payload = _normalizeJsonMap(data['data']);
    final rawList = payload['data'] is List
        ? List<dynamic>.from(payload['data'] as List)
        : <dynamic>[];

    return HistoryPaginatedModel(
      currentPage: _parseInt(payload['current_page']) ?? 1,
      perPage: _parseInt(payload['per_page']) ?? 0,
      total: _parseInt(payload['total']) ?? 0,
      items: rawList.map((e) => HistoryItemModel.fromJson(e)).toList(),
    );
  }

  bool get hasMore => currentPage * perPage < total;
}
