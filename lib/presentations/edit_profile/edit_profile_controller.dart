import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  RxString firstName = "".obs;
  RxString firstNameError = "".obs;

  RxString lastName = "".obs;
  RxString lastNameError = "".obs;
  RxString email = "".obs;
  RxBool isLoading = false.obs;
  RxBool isUpdateLoading = false.obs;

  bool validation() {
    RxBool isValid = true.obs;
    firstNameError.value = "";
    lastNameError.value = "";

    if (firstName.trim().isEmpty) {
      firstNameError.value = "Please enter first name";
      isValid.value = false;
    } else if (firstName.value.length < 3) {
      firstNameError.value = "First name must be at least 3 characters long";
      isValid.value = false;
    }

    if (lastName.trim().isEmpty) {
      lastNameError.value = "Please enter last name";
      isValid.value = false;
    } else if (lastName.value.length < 3) {
      lastNameError.value = "Last name must be at least 3 characters long";
      isValid.value = false;
    }
    return isValid.value;
  }

  Future<void> getUserDetails() async {
    isLoading.value = true;
    QuerySnapshot snapshot =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserData(LocalStorage.userEmail.value);

    firstName.value = snapshot.docs[0]['full_name'].split(" ")[0];
    lastName.value = snapshot.docs[0]['full_name'].split(" ")[1];
    email.value = snapshot.docs[0]['email'];
    isLoading.value = false;
  }

  Future<void> updateUserData() async {
    isUpdateLoading.value = true;
    await DatabaseService(uid: LocalStorage.userId.value.trim())
        .updateUserData("${firstName.value} ${lastName.value}", email.value);
    LocalStorage.saveLocalData(
      isLoginFlag: true,
      name: "${firstName.value} ${lastName.value}",
      email: email.value,
      userID: LocalStorage.userId.value.trim(),
    );
    LocalStorage.loadLocalData();
    Get.back();
    isUpdateLoading.value = false;
  }

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }
}
