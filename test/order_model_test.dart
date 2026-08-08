import 'package:delivery_app/features/orders/data/models/order_model.dart';
import 'package:delivery_app/features/orders/presentation/controller/orders_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses pending request payload safely', () {
    final payload = {
      'id': 12,
      'type': 'device_pickup',
      'status': 'pending',
      'payment_method': 'cash_on_delivery',
      'cash_collected': false,
      'confirmed_at': null,
      'notes': 'Please call before arrival',
      'created_at': '2024-08-01T10:00:00Z',
      'delivery_worker_id': 7,
      'customer_id': 4,
      'shop_id': 9,
      'customer': {
        'first_name': 'John',
        'last_name': 'Doe',
        'phone': '01000000000',
      },
      'shop': {'name': 'Nile Shop', 'address': 'Cairo'},
      'maintenance_request': {
        'tracking_number': 'TRK123',
        'device_model': 'iPhone 14',
        'status': 'pending',
      },
      'latitude': '30.0444',
      'longitude': '31.2357',
    };

    final order = OrderModel.fromJson(payload);

    expect(order.id, 12);
    expect(order.type, 'device_pickup');
    expect(order.status, 'pending');
    expect(order.customerName, 'John Doe');
    expect(order.customerPhone, '01000000000');
    expect(order.shopName, 'Nile Shop');
    expect(order.maintenanceTrackingNumber, 'TRK123');
    expect(order.latitude, 30.0444);
    expect(order.longitude, 31.2357);
  });

  test('parses a JSON string payload', () {
    final payload =
        '{"id": 21, "type": "accessory_delivery", "status": "pending", "payment_method": "prepaid", "customer": {"first_name": "Sara", "last_name": "Mansour", "phone": "+963999111222"}, "shop": {"name": "Shamsung", "address": "Damascus"}}';

    final order = OrderModel.fromJson(payload);

    expect(order.id, 21);
    expect(order.type, 'accessory_delivery');
    expect(order.customerName, 'Sara Mansour');
    expect(order.shopName, 'Shamsung');
  });

  test('parses estimated cost from maintenance requests', () {
    final payload = {
      'id': 14,
      'type': 'maintenance_delivery',
      'status': 'pending',
      'payment_method': 'prepaid',
      'maintenance_request': {
        'tracking_number': 'TRK999',
        'device_model': 'Galaxy A54',
        'status': 'approved',
        'estimated_cost': '180000',
      },
    };

    final order = OrderModel.fromJson(payload);

    expect(order.maintenanceTrackingNumber, 'TRK999');
    expect(order.estimatedCost, '180000');
  });

  test('parses estimated cost for device pickup requests', () {
    final payload = {
      'id': 15,
      'type': 'device_pickup',
      'status': 'pending',
      'payment_method': 'cash_on_delivery',
      'maintenance_request': {
        'tracking_number': 'TRK100',
        'device_model': 'iPhone 15',
        'status': 'approved',
        'estimated_cost': '220000',
      },
    };

    final order = OrderModel.fromJson(payload);

    expect(order.type, 'device_pickup');
    expect(order.estimatedCost, '220000');
  });

  test('filters device pickup requests from request list unless completed', () {
    final pendingPickup = OrderModel.fromJson({
      'id': 16,
      'type': 'device_pickup',
      'status': 'pending',
      'maintenance_request': {'customer_status': 'approved'},
    });
    final completedPickup = OrderModel.fromJson({
      'id': 17,
      'type': 'device_pickup',
      'status': 'pending',
      'maintenance_request': {'customer_status': 'completed'},
    });
    final accessory = OrderModel.fromJson({
      'id': 18,
      'type': 'accessory_delivery',
      'status': 'pending',
    });

    expect(shouldShowInRequests(pendingPickup), isFalse);
    expect(shouldShowInRequests(completedPickup), isTrue);
    expect(shouldShowInRequests(accessory), isTrue);
  });

  test('falls back to defaults when nested data is missing', () {
    final order = OrderModel.fromJson({
      'id': '99',
      'type': null,
      'status': null,
      'payment_method': null,
      'cash_collected': null,
      'created_at': null,
      'latitude': null,
      'longitude': null,
    });

    expect(order.id, 99);
    expect(order.type, '');
    expect(order.status, '');
    expect(order.paymentMethod, '');
    expect(order.customerName, 'Unknown');
    expect(order.customerPhone, '');
    expect(order.shopName, 'Unknown');
    expect(order.latitude, isNull);
    expect(order.longitude, isNull);
  });
}
