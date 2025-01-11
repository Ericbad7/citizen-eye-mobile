import 'package:citizeneye/data/datasources/user_local_storage.dart';
import 'package:citizeneye/data/models/petition_model.dart';
import 'package:citizeneye/logic/services/petition_service.dart';
import 'package:get/get.dart';

class PostViewController extends GetxController {
  var petitions = <PetitionModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  String? id;
  PostViewController();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    id = await UserLocalStorage.getId();
    if (id != null) {
      fetchMyPetitions(id!);
    } else {
      fetchPetitions();
    }
  }

  Future<void> refresher() async {
    id = await UserLocalStorage.getId();
    if (id != null) {
      fetchMyPetitions(id!);
    } else {
      fetchPetitions();
    }
  }

  Future<void> fetchMyPetitions(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    final response = await getMyPetitions(id);
    if (response["status"]) {
      petitions.value = response['petitions'];
      isLoading.value = false;
    } else {
      errorMessage.value = response['message'];
      isLoading.value = false;
    }
  }

  Future<void> fetchPetitions() async {
    isLoading.value = true;
    errorMessage.value = '';
    final response = await getPetitions();
    if (response["status"]) {
      petitions.value = response['petitions'];
      isLoading.value = false;
    } else {
      errorMessage.value = response['message'];
      isLoading.value = false;
    }
  }
}
