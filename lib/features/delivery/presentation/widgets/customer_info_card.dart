import 'package:flutter/material.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: const Text("Ahmed Ali"),
        subtitle: const Text("+963936539965"),
        trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
      ),
    );
  }
}
