import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<void> onJoin(type) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    Get.toNamed(
      AppRoutes.pickupScreen,
      arguments: contactModel,
      parameters: {"type": type},
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    await permission.request();
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
