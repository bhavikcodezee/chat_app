import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/database_service.dart';

class ChatMemberController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void onInit() {
    getConversation(false);
    super.onInit();
  }

  Stream? conversationStrem;
  RxString email = "".obs;
  RxString userName = "".obs;
  RxString groupName = "".obs;
  RxBool isLoading = false.obs;

  Future<void> getConversation(bool filter) async {
    isLoading.value = true;
    email = LocalStorage.userEmail;
    userName = LocalStorage.userName;
    if (filter) {
      conversationStrem =
          (await DatabaseService(uid: LocalStorage.userId.value.trim())
              .getConversationGroupList(LocalStorage.userId.value.trim()));
    } else {
      conversationStrem =
          (await DatabaseService(uid: LocalStorage.userId.value.trim())
              .getConversationList(LocalStorage.userId.value.trim()));
    }

    isLoading.value = false;
  }
}
