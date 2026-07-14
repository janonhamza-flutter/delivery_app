import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 220,
        alignment: Alignment.center,
        child: const Text("Google Map Here", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
