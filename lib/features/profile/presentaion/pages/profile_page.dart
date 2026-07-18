import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../controller/profile_controller.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';

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
              ProfileHeader(profile: profile),

              const SizedBox(height: 25),

              ProfileInfoCard(profile: profile),

              const SizedBox(height: 30),

              LogoutButton(
                onLogout: () {
                  Get.defaultDialog(
                    title: "Logout",
                    middleText: "Are you sure you want to logout?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      Get.back();
                      controller.logout();
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
