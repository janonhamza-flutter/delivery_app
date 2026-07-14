import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Device",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_android),
              title: Text("Galaxy S25 Ultra"),
              subtitle: Text("IMEI : 123456789012345"),
            ),

            SizedBox(height: 10),

            Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 5),

            Text("Please call before arriving."),
          ],
        ),
      ),
    );
  }
}
