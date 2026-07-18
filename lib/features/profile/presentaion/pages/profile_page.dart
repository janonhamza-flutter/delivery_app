import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.profile.value == null) {
          return const Center(child: Text("No Profile Data"));
        }

        final profile = controller.profile.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(Icons.person, size: 45),
              ),

              const SizedBox(height: 20),

              Text(
                "${profile.firstName} ${profile.lastName}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                profile.specialization,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(profile.phone),
                    ),

                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(profile.email),
                    ),

                    ListTile(
                      leading: const Icon(Icons.work),
                      title: Text(profile.experience),
                    ),

                    ListTile(
                      leading: const Icon(Icons.store),
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
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.logout();
                    // سنربطه لاحقًا مع Logout API
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
