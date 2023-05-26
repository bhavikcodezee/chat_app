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
  RxBool isLoading = false.obs;

  Future<void> getConversation(bool filter) async {
    isLoading.value = true;
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
