class OrderModel {
  final int id;
  final String type;
  final String status;
  final String paymentMethod;

  final String customerName;
  final String customerPhone;

  final String shopName;
  final String shopAddress;

  final double? latitude;
  final double? longitude;

  OrderModel({
    required this.id,
    required this.type,
    required this.status,
    required this.paymentMethod,
    required this.customerName,
    required this.customerPhone,
    required this.shopName,
    required this.shopAddress,
    required this.latitude,
    required this.longitude,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      type: json["type"],
      status: json["status"],
      paymentMethod: json["payment_method"],

      customerName:
          "${json["customer"]["first_name"]} ${json["customer"]["last_name"]}",

      customerPhone: json["customer"]["phone"],

      shopName: json["shop"]["name"],

      shopAddress: json["shop"]["address"],

      latitude: double.tryParse(json["latitude"]?.toString() ?? ""),
      longitude: double.tryParse(json["longitude"]?.toString() ?? ""),
    );
  }
}
