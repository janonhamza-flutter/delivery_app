import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/theme/app_colors.dart';

class OtpPinField extends StatelessWidget {
  final TextEditingController controller;

  const OtpPinField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,

      controller: controller,

      length: 5,

      keyboardType: TextInputType.number,

      animationType: AnimationType.fade,

      autoFocus: true,

      onChanged: (_) {},

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,

        borderRadius: BorderRadius.circular(15),

        fieldHeight: 60,

        fieldWidth: 60,

        activeFillColor: Colors.white,

        selectedFillColor: Colors.white,

        inactiveFillColor: Colors.white,

        activeColor: AppColors.primary,

        selectedColor: AppColors.primary,

        inactiveColor: Colors.grey.shade400,
      ),
    );
  }
}
