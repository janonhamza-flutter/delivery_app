class OrderDetailsModel {
  final int id;
  final String customerName;
  final String phone;
  final String address;
  final String deviceName;
  final String imei;
  final String notes;

  OrderDetailsModel({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.deviceName,
    required this.imei,
    required this.notes,
  });
}
