import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Customer",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text("Ahmed Ali"),
              subtitle: const Text("+963936539965"),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
