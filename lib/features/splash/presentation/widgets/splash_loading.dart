import 'dart:async';

import 'package:delivery_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


/// Muted, cross-fading status caption shown above the progress bar.
class SplashLoading extends StatefulWidget {
  const SplashLoading({super.key});

  @override
  State<SplashLoading> createState() => _SplashLoadingState();
}

class _SplashLoadingState extends State<SplashLoading> {
  static const _messageKeys = [
    'splash.msgPreparing',
    'splash.msgRealtimeTracking',
    'splash.msgAlmostReady',
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % _messageKeys.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Text(
          _messageKeys[_index].tr,
          key: ValueKey(_index),
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: AppColors.white.withOpacity(0.55),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ).animate(delay: 400.ms).fade(duration: 500.ms),
    );
  }
}
