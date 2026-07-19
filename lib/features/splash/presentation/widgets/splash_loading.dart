import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40),

        SizedBox(
          width: 240,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(Color(0xff42E76D)),
            ),
          ),
        ),

        SizedBox(height: 20),

        Text(
          "Loading...",
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ).animate(delay: 900.ms).fade(),
      ],
    );
  }
}
