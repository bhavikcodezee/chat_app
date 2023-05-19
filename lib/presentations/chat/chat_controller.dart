import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  String admin = "";
  Stream<QuerySnapshot>? messages;
  RxList senderList = [].obs;

  TextEditingController messageController = TextEditingController();
  ContactModel? contactModel;
  bool isConversationNew = false;
  String? conversationId;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      isConversationNew = Get.arguments[0];
      contactModel = Get.arguments[1];
    }

    if (!isConversationNew) {
      getMessages();
    }
    super.onInit();
  }

  Future<void> createConversation(context) async {
    isLoading.value = true;
    await DatabaseService(uid: LocalStorage.userId).createConversation(
      contactsId: [],
      groupName: "",
      uid: LocalStorage.userId,
      userName: LocalStorage.userName,
    );
    isLoading.value = false;
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender_id": LocalStorage.userId,
        "receiver_id": contactModel?.uid ?? "",
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(conversationId ?? "", chatMessageMap);
      messageController.clear();
    }
  }

  Future<void> getMessages() async {
    messages = await DatabaseService().getMessages(conversationId ?? "");
    // DatabaseService().getGroupAdmin(conversationId).then((value) {
    //   admin = value;
    // });
  }
}
