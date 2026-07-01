import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const splashTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const pageTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static const title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const body = TextStyle(fontSize: 15, color: AppColors.darkGrey);

  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
