import 'package:get/get.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController(this.repository);

  final ProfileRepository repository;

  final isLoading = false.obs;

  Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    getProfile();

    super.onInit();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      final response = await repository.getProfile();

      profile.value = ProfileModel.fromJson(response.data["data"]);
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      print("Before Logout");
      await repository.logout();
      print("Logout Success");
      StorageService.clearToken();

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('common.error'.tr, 'profile.logoutFailed'.tr);
    }
  }
}
