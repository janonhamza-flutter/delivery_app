import 'package:delivery_app/core/services/dio_service.dart';
import 'package:delivery_app/features/orders/data/models/order_model.dart';
import 'package:delivery_app/features/orders/data/repositories/order_repository.dart';
import 'package:delivery_app/features/orders/presentation/controller/orders_controller.dart';
import 'package:delivery_app/features/ordrer_details/data/repositories/order_details_repository.dart';
import 'package:delivery_app/features/ordrer_details/presentation/controller/order_details_controller.dart';
import 'package:delivery_app/features/ordrer_details/presentation/pages/order_details_page.dart';
import 'package:delivery_app/features/ordrer_details/presentation/widgets/button_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class FakeOrderDetailsController extends OrderDetailsController {
  FakeOrderDetailsController() : super(FakeOrderDetailsRepository());

  bool fetchCalled = false;

  @override
  Future<void> fetchRequestDetails({required int requestId}) async {
    fetchCalled = true;
  }
}

class FakeOrderDetailsRepository extends OrderDetailsRepository {
  FakeOrderDetailsRepository() : super(DioService());
}

class FakeOrdersController extends OrdersController {
  FakeOrdersController() : super(FakeOrdersRepository());

  @override
  void onInit() {}
}

class FakeOrdersRepository extends OrdersRepository {
  FakeOrdersRepository() : super(DioService());
}

void main() {
  testWidgets('fetches request details when the page is initialized', (
    tester,
  ) async {
    Get.testMode = true;
    final controller = FakeOrderDetailsController();
    Get.put<OrderDetailsController>(controller);

    final order = OrderModel(
      id: 5,
      type: 'device_pickup',
      status: 'pending',
      paymentMethod: 'cash_on_delivery',
      customerName: 'Ahmad Ali',
      customerPhone: '+963933111222',
      shopName: 'Shamsung Damascus',
      shopAddress: 'Mazzeh Street',
      latitude: 33.5138,
      longitude: 36.2765,
    );

    Get.put<OrdersController>(FakeOrdersController());

    await tester.pumpWidget(
      GetMaterialApp(
        home: const Scaffold(body: SizedBox()),
        getPages: [GetPage(name: '/details', page: () => OrderDetailsPage())],
      ),
    );

    Get.to(() => OrderDetailsPage(), arguments: order);
    await tester.pumpAndSettle();

    expect(controller.fetchCalled, isTrue);
  });

  testWidgets(
    'enables the accept button only for completed device pickup requests',
    (tester) async {
      Get.testMode = true;
      Get.reset();
      final ordersController = FakeOrdersController();
      Get.put<OrdersController>(ordersController);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtons(
              order: OrderModel(
                id: 7,
                type: 'device_pickup',
                status: 'pending',
                paymentMethod: 'cash_on_delivery',
                maintenanceStatus: 'completed',
                customerName: 'Ahmad',
                customerPhone: '+963999111222',
                shopName: 'Shop',
                shopAddress: 'Address',
                latitude: 0,
                longitude: 0,
              ),
            ),
          ),
        ),
      );

      var button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtons(
              order: OrderModel(
                id: 8,
                type: 'device_pickup',
                status: 'pending',
                paymentMethod: 'cash_on_delivery',
                maintenanceStatus: 'pending',
                customerName: 'Ahmad',
                customerPhone: '+963999111222',
                shopName: 'Shop',
                shopAddress: 'Address',
                latitude: 0,
                longitude: 0,
              ),
            ),
          ),
        ),
      );

      button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtons(
              order: OrderModel(
                id: 9,
                type: 'accessory_delivery',
                status: 'pending',
                paymentMethod: 'cash_on_delivery',
                customerName: 'Ahmad',
                customerPhone: '+963999111222',
                shopName: 'Shop',
                shopAddress: 'Address',
                latitude: 0,
                longitude: 0,
              ),
            ),
          ),
        ),
      );

      button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    },
  );
}
