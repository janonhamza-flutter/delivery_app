class ActiveDeliveryModel {
  final int id;

  final String customerName;

  final String phone;

  final String address;

  final double latitude;

  final double longitude;

  final double cashAmount;

  final String status;

  ActiveDeliveryModel({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.cashAmount,
    required this.status,
  });

  factory ActiveDeliveryModel.fromJson(Map<String, dynamic> json) {
    return ActiveDeliveryModel(
      id: json["id"],
      customerName: json["customer_name"],
      phone: json["phone"],
      address: json["address"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      cashAmount: (json["cash_amount"] as num).toDouble(),
      status: json["status"],
    );
  }
}
