import 'dart:io';

import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/app_colors.dart';

class EditProfileController extends GetxController {
  RxString firstName = "".obs;
  RxString firstNameError = "".obs;

  RxString lastName = "".obs;
  RxString lastNameError = "".obs;
  RxString email = "".obs;
  RxBool isLoading = false.obs;
  RxBool isUpdateLoading = false.obs;

  RxString selectedProfile = ''.obs;
  RxBool showLoading = false.obs;
  Rx<File> croppedProfile = File("").obs;

  RxString emailError = ''.obs;
  RxString phoneNumberError = ''.obs;
  RxString url = "".obs;

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

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

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadPic() async {
    Reference reference = _storage.ref().child("images/");
    UploadTask uploadTask = reference.putFile(croppedProfile.value);
    await uploadTask.whenComplete(() async {
      url.value = await reference.getDownloadURL();
      Get.back();
    });
  }

  Future<void> getUserDetails() async {
    isLoading.value = true;
    QuerySnapshot snapshot =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .gettingUserData(LocalStorage.userEmail.value);
    firstName.value = snapshot.docs[0]['full_name'].split(" ")[0];
    lastName.value = snapshot.docs[0]['full_name'].split(" ")[1];
    email.value = snapshot.docs[0]['email'];
    url.value = snapshot.docs[0]['profile_pic'];
    isLoading.value = false;
  }

  Future<void> updateUserData() async {
    isUpdateLoading.value = true;
    await DatabaseService(uid: LocalStorage.userId.value.trim()).updateUserData(
      fullName: "${firstName.value} ${lastName.value}",
      email: email.value,
      profilePic: url.value,
    );
    await uploadPic();
    LocalStorage.saveLocalData(
      isLoginFlag: true,
      name: "${firstName.value} ${lastName.value}",
      email: email.value,
      userID: LocalStorage.userId.value.trim(),
      image: url.value,
    );
    LocalStorage.loadLocalData();
    isUpdateLoading.value = false;
  }

  Future pickImage(bool fromGallery) async {
    XFile? pickedImage = await ImagePicker().pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedImage != null) {
      showLoading.value = true;
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit',
            lockAspectRatio: true,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            statusBarColor: AppColors.primaryColor,
            toolbarColor: AppColors.primaryColor,
          ),
          IOSUiSettings(title: 'Edit'),
        ],
      );
      if (croppedFile != null) {
        croppedProfile.value = File(croppedFile.path);
        showLoading.value = false;
        selectedProfile.value = croppedProfile.value.path;

        Get.back();
      } else {
        showLoading.value = false;
      }
    } else {
      showLoading.value = false;
    }
  }
}
