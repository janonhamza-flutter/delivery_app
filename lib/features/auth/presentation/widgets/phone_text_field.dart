import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,

      decoration: InputDecoration(
        hintText: "9XXXXXXXX",

        prefixIcon: const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "+963",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Phone number is required";
        }

        if (value.length != 9) {
          return "Invalid phone number";
        }

        return null;
      },
    );
  }
}
