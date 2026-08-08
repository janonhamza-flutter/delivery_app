import 'dart:convert';

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

class OrderModel {
  final int id;
  final String type;
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

  final double? latitude;
  final double? longitude;

  OrderModel({
    required this.id,
    required this.type,
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
      final inferredType = data["type"]?.toString() ??
          (data["items"] is List ? 'accessory_delivery' : '');
      final directCustomerId = data["customer_id"]?.toString();

      return OrderModel(
        id: _parseInt(data["id"]) ?? 0,
        type: inferredType,
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
}
