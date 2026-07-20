import 'package:flutter/material.dart';

import '../../data/models/profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: Text(profile.phone),
          ),

          ListTile(
            leading: const Icon(Icons.email),
            title: Text(profile.email),
          ),

          ListTile(
            leading: const Icon(Icons.badge),
            title: Text(profile.experience),
          ),

          ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(profile.shopName),
            subtitle: Text(profile.shopAddress),
          ),

          ListTile(
            leading: Icon(
              profile.isActive ? Icons.check_circle : Icons.cancel,
              color: profile.isActive ? Colors.green : Colors.red,
            ),
            title: Text(profile.isActive ? "Active" : "Inactive"),
          ),
        ],
      ),
    );
  }
}
