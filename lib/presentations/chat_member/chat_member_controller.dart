import 'package:chat_app/presentations/chat_member/chat_member_screen.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/database_service.dart';

class ChatMemberController extends GetxController {
  @override
  void onInit() {
    gettingUserDetails();
    super.onInit();
  }

  RxString email = "".obs;
  RxString userName = "".obs;
  RxString groupName = "".obs;

  RxBool isLoading = false.obs;
  RxBool isdata = false.obs;

  Stream? groups;

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  Future<void> gettingUserDetails() async {
    email.value = LocalStorage.userEmailKey;
    userName.value = LocalStorage.useNameKey;

    await DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid)
        .getUserGroups()
        .then((snapshot) {
      groups = snapshot;
    });
  }

  Future<void> createGroup(context) async {
    if (groupName.value != "") {
      isLoading.value;

      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .createGroup(userName.value, FirebaseAuth.instance.currentUser!.uid,
              groupName.value)
          .whenComplete(() {
        isLoading.value = false;
      });
      Get.back();
      showSnackbar(context, Colors.green, "Group create successfully.");
    }
  }
}
