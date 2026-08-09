import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

      decoration: InputDecoration(
        hintText: 'auth.phoneNumberHint'.tr,
        hintStyle: TextStyle(color: Colors.grey.shade500),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),

        prefixIconConstraints: const BoxConstraints(minWidth: 0),

        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "+963",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(width: 10),

              Container(width: 1, height: 22, color: Colors.grey.shade300),

              const SizedBox(width: 10),
            ],
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.8),
        ),
      ),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'auth.phoneRequired'.tr;
        }

        if (value.length != 9) {
          return 'auth.phoneMustBe9Digits'.tr;
        }

        return null;
      },
    );
  }
}
