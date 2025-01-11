import 'package:citizeneye/data/models/user_profile_model.dart';
import 'package:citizeneye/logic/services/user_service.dart';
import 'package:get/get.dart';

class ProfileViewController extends GetxController {
  var profile = UserProfile().obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  ProfileViewController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    final response = await getMyProfile();
    if (response["status"]) {
      profile.value = response['profile'];
      isLoading.value = false;
    } else {
      errorMessage.value = response['message'];
      isLoading.value = false;
    }
  }
}
