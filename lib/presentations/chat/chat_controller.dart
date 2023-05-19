import 'package:chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  String groupId = Get.arguments[0];
  String groupName = Get.arguments[1];
  String userName = Get.arguments[2];

  String admin = "";
  Stream<QuerySnapshot>? chats;

  RxList senderList = [].obs;

  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    getChatAndAdmin();
    super.onInit();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(groupId).then((val) {
      chats = val;
    });

    DatabaseService().getGroupAdmin(groupId).then((value) {
      admin = value;
    });
  }
}
