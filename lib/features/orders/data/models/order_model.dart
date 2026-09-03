import 'dart:convert';

import 'package:get/get.dart';

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

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

class AccessoryModel {
  final int id;
  final int? shopId;
  final String? name;
  final String? nameAr;
  final String? nameEn;

  AccessoryModel({
    required this.id,
    this.shopId,
    this.name,
    this.nameAr,
    this.nameEn,
  });

  factory AccessoryModel.fromJson(Map<String, dynamic> json) {
    return AccessoryModel(
      id: _parseInt(json["id"]) ?? 0,
      shopId: _parseInt(json["shop_id"]),
      name: json["name"]?.toString(),
      nameAr: json["name_ar"]?.toString(),
      nameEn: json["name_en"]?.toString(),
    );
  }

  /// Product name in the app's current language, falling back to whatever
  /// name is available.
  String get localizedName {
    final isArabic = Get.locale?.languageCode == 'ar';
    final preferred = isArabic ? nameAr : nameEn;
    if (preferred != null && preferred.isNotEmpty) return preferred;
    final fallback = isArabic ? nameEn : nameAr;
    if (fallback != null && fallback.isNotEmpty) return fallback;
    return name ?? '';
  }
}

class OrderModel {
  final int id;
  final String type;
  final String? direction;
  final String status;
  final String paymentMethod;
  final bool cashCollected;
  final String? confirmedAt;
  final String? notes;
  final String createdAt;

  final int? deliveryWorkerId;
  final int? customerId;
  final int? shopId;

  final String customerName;
  final String customerPhone;

  final String shopName;
  final String shopAddress;
  final String? address;
  final String? orderNumber;
  final String? totalAmount;

  // Maintenance request details (for device_pickup type)
  final String? maintenanceTrackingNumber;
  final String? maintenanceDeviceModel;
  final String? maintenanceStatus;
  final String? maintenanceCustomerStatus;
  final String? estimatedCost;

  // Accessory details (for accessory_delivery type)
  final AccessoryModel? accessory;

  final double? latitude;
  final double? longitude;

  OrderModel({
    required this.id,
    required this.type,
    this.direction,
    required this.status,
    required this.paymentMethod,
    this.cashCollected = false,
    this.confirmedAt,
    this.notes,
    this.createdAt = '',
    this.deliveryWorkerId,
    this.customerId,
    this.shopId,
    required this.customerName,
    required this.customerPhone,
    required this.shopName,
    required this.shopAddress,
    this.address,
    this.orderNumber,
    this.totalAmount,
    this.maintenanceTrackingNumber,
    this.maintenanceDeviceModel,
    this.maintenanceStatus,
    this.maintenanceCustomerStatus,
    this.estimatedCost,
    this.accessory,
    required this.latitude,
    required this.longitude,
  });

  factory OrderModel.fromJson(dynamic json) {
    final data = _normalizeJsonMap(json);

    try {
      final maintenance = data["maintenance_request"] is Map
          ? Map<String, dynamic>.from(data["maintenance_request"] as Map)
          : null;
      final customer = data["customer"] is Map
          ? Map<String, dynamic>.from(data["customer"] as Map)
          : <String, dynamic>{};
      final shop = data["shop"] is Map
          ? Map<String, dynamic>.from(data["shop"] as Map)
          : <String, dynamic>{};
      final order = data["order"] is Map
          ? Map<String, dynamic>.from(data["order"] as Map)
          : <String, dynamic>{};

      // The accessory object may sit at the top level, on the nested
      // "order", or on the first line item of an "items" array (whichever
      // of those the backend attaches it to).
      final items = data["items"] is List
          ? data["items"] as List
          : (order["items"] is List ? order["items"] as List : const []);
      final firstItem = items.isNotEmpty && items.first is Map
          ? Map<String, dynamic>.from(items.first as Map)
          : <String, dynamic>{};

      final rawAccessory =
          data["accessory"] ?? order["accessory"] ?? firstItem["accessory"];
      final accessory = rawAccessory is Map
          ? AccessoryModel.fromJson(Map<String, dynamic>.from(rawAccessory))
          : null;

      final inferredType = data["type"]?.toString() ??
          (data["items"] is List ? 'accessory_delivery' : '');
      final directCustomerId = data["customer_id"]?.toString();

      return OrderModel(
        id: _parseInt(data["id"]) ?? 0,
        type: inferredType,
        direction: data["direction"]?.toString(),
        status: data["status"]?.toString() ?? "",
        paymentMethod: data["payment_method"]?.toString() ?? "",
        cashCollected: data["cash_collected"] is bool
            ? data["cash_collected"] as bool
            : false,
        confirmedAt: data["confirmed_at"]?.toString(),
        notes: data["notes"]?.toString(),
        createdAt: data["created_at"]?.toString() ?? '',
        deliveryWorkerId: _parseInt(data["delivery_worker_id"]),
        customerId: _parseInt(data["customer_id"]),
        shopId: _parseInt(data["shop_id"]),

        customerName: (() {
          final firstName = customer["first_name"]?.toString() ?? "";
          final lastName = customer["last_name"]?.toString() ?? "";
          final fullName = [
            firstName,
            lastName,
          ].where((value) => value.isNotEmpty).join(' ').trim();
          if (fullName.isNotEmpty) {
            return fullName;
          }

          final customerNameFromPayload = data["customer_name"]?.toString();
          if (customerNameFromPayload != null && customerNameFromPayload.isNotEmpty) {
            return customerNameFromPayload;
          }

          if (directCustomerId != null && directCustomerId.isNotEmpty) {
            return 'Customer #$directCustomerId';
          }

          return 'Unknown';
        })(),
        customerPhone: customer["phone"]?.toString() ?? "",

        shopName: shop["name"]?.toString() ?? "Unknown",
        shopAddress: shop["address"]?.toString() ?? "",
        address: data["address"]?.toString() ?? shop["address"]?.toString(),
        orderNumber:
            data["order_number"]?.toString() ?? order["order_number"]?.toString(),
        totalAmount:
            data["total_amount"]?.toString() ?? order["total_amount"]?.toString(),

        maintenanceTrackingNumber: maintenance?["tracking_number"]?.toString(),
        maintenanceDeviceModel: maintenance?["device_model"]?.toString(),
        maintenanceStatus: maintenance?["status"]?.toString(),
        maintenanceCustomerStatus: maintenance?["customer_status"]?.toString(),
        accessory: accessory,
        estimatedCost: maintenance?["estimated_cost"]?.toString(),

        latitude: double.tryParse(data["latitude"]?.toString() ?? ""),
        longitude: double.tryParse(data["longitude"]?.toString() ?? ""),
      );
    } catch (_) {
      return OrderModel(
        id: 0,
        type: '',
        status: '',
        paymentMethod: '',
        customerName: 'Unknown',
        customerPhone: '',
        shopName: 'Unknown',
        shopAddress: '',
        address: null,
        orderNumber: null,
        totalAmount: null,
        estimatedCost: null,
        maintenanceCustomerStatus: null,
        latitude: null,
        longitude: null,
      );
    }
  }

  OrderModel copyWith({
    String? status,
    bool? cashCollected,
    String? confirmedAt,
  }) {
    return OrderModel(
      id: id,
      type: type,
      direction: direction,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      cashCollected: cashCollected ?? this.cashCollected,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      notes: notes,
      createdAt: createdAt,
      deliveryWorkerId: deliveryWorkerId,
      customerId: customerId,
      shopId: shopId,
      customerName: customerName,
      customerPhone: customerPhone,
      shopName: shopName,
      shopAddress: shopAddress,
      address: address,
      orderNumber: orderNumber,
      totalAmount: totalAmount,
      maintenanceTrackingNumber: maintenanceTrackingNumber,
      maintenanceDeviceModel: maintenanceDeviceModel,
      maintenanceStatus: maintenanceStatus,
      maintenanceCustomerStatus: maintenanceCustomerStatus,
      estimatedCost: estimatedCost,
      accessory: accessory,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
