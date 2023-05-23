import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  String admin = "";
  Stream? messages;
  RxList senderList = [].obs;

  TextEditingController messageController = TextEditingController();
  ContactModel? contactModel;
  String? conversationId;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      contactModel = Get.arguments[1];
      conversationId = contactModel?.conversationID ?? "";
    }
    getMessages();
    super.onInit();
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender_id": LocalStorage.userId.value.trim(),
        "receiver_id": contactModel?.uid ?? "",
        "receiver_name": contactModel?.fullName ?? "",
        "sender_name": LocalStorage.userName.value,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendMessage(conversationId ?? "", chatMessageMap);
      messageController.clear();
    } else {
      Get.snackbar("Error", "Empty message not allow",
          backgroundColor: Colors.red, colorText: AppColors.whiteColor);
    }
  }

  Future<void> getMessages() async {
    isLoading.value = true;
    messages = await DatabaseService().getMessages(conversationId ?? "");
    isLoading.value = false;
  }
}
