import 'package:flutter/material.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 40),

        SizedBox(width: 220, child: LinearProgressIndicator()),

        SizedBox(height: 15),

        Text("Loading...", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
