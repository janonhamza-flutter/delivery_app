import 'dart:convert';

Map<String, dynamic> _normalizeMap(dynamic value) {
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

class EarningsDeliveryItem {
  final int id;
  final String type;
  final String status;
  final String paymentMethod;
  final bool cashCollected;
  final String? cashAmount;
  final String? confirmedAt;
  final String customerName;
  final String shopName;

  EarningsDeliveryItem({
    required this.id,
    required this.type,
    required this.status,
    required this.paymentMethod,
    required this.cashCollected,
    this.cashAmount,
    this.confirmedAt,
    required this.customerName,
    required this.shopName,
  });

  factory EarningsDeliveryItem.fromJson(dynamic json) {
    final data = _normalizeMap(json);
    final customer = _normalizeMap(data['customer']);
    final shop = _normalizeMap(data['shop']);

    return EarningsDeliveryItem(
      id: (data['id'] as num?)?.toInt() ?? 0,
      type: data['type']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      paymentMethod: data['payment_method']?.toString() ?? '',
      cashCollected: data['cash_collected'] is bool
          ? data['cash_collected'] as bool
          : false,
      cashAmount: data['cash_amount']?.toString(),
      confirmedAt: data['confirmed_at']?.toString(),
      customerName:
          '${customer['first_name']?.toString() ?? ''} ${customer['last_name']?.toString() ?? ''}'
              .trim(),
      shopName: shop['name']?.toString() ?? 'Unknown',
    );
  }
}

class EarningsModel {
  final int totalDeliveries;
  final double totalCash;
  final List<EarningsDeliveryItem> deliveries;

  EarningsModel({
    required this.totalDeliveries,
    required this.totalCash,
    required this.deliveries,
  });

  factory EarningsModel.fromJson(dynamic json) {
    final payload = _normalizeMap(json);
    final root = payload['data'] is Map
        ? _normalizeMap(payload['data'])
        : payload;

    return EarningsModel(
      totalDeliveries: (root['total_deliveries'] as num?)?.toInt() ?? 0,
      totalCash: (root['total_cash'] as num?)?.toDouble() ?? 0,
      deliveries: (() {
        final rawDeliveries = root['deliveries'];
        if (rawDeliveries is List) {
          return rawDeliveries
              .map((e) => EarningsDeliveryItem.fromJson(e))
              .toList();
        }
        return <EarningsDeliveryItem>[];
      })(),
    );
  }

  factory EarningsModel.empty() =>
      EarningsModel(totalDeliveries: 0, totalCash: 0, deliveries: []);
}
