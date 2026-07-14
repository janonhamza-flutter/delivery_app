import 'package:flutter/material.dart';

class CashCard extends StatelessWidget {
  const CashCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: const [
            Text("Cash To Collect", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              "75,000 SYP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
