import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/route/app_pages.dart';
import 'core/route/app_routes.dart';

void main() {
  runApp(const DeliveryApp());
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
