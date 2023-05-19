import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/database_service.dart';

class ChatMemberController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void onInit() {
    gettingUser();
    super.onInit();
  }

  Stream? stream;
  RxString email = "".obs;
  RxString userName = "".obs;
  RxString groupName = "".obs;
  RxBool isLoading = false.obs;
  List userList = [];

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  Future<void> gettingUser() async {
    isLoading.value = true;
    email.value = LocalStorage.userEmail;
    userName.value = LocalStorage.userName;
    userList = (await DatabaseService(uid: LocalStorage.userId)
            .getContactList(email.value))
        .docs;

    isLoading.value = false;
  }
}
