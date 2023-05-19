import 'dart:convert';

import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/presentations/chat_member/chat_member_screen.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  RxBool isLoading = false.obs;
  List<ContactModel> contactList = [];
  RxList<String> selectedContactList = <String>[].obs;
  RxString groupName = "".obs;
  RxBool isGroup = false.obs;

  @override
  void onInit() {
    getContacts();
    super.onInit();
  }

  void onTap(String uid) {
    if (selectedContactList.contains(uid)) {
      selectedContactList.remove(uid);
    } else {
      selectedContactList.add(uid);
    }
  }

  Future<void> getContacts() async {
    isLoading.value = true;
    List<QueryDocumentSnapshot> queryDocumentList =
        (await DatabaseService(uid: LocalStorage.userId)
                .getContactList(LocalStorage.userEmail))
            .docs;

    for (QueryDocumentSnapshot queryDocumentSnapshot in queryDocumentList) {
      var resData = jsonDecode(jsonEncode((queryDocumentSnapshot.data())));
      contactList.add(ContactModel(
          email: resData['email'],
          fullName: resData['full_name'],
          profilepic: "",
          uid: resData['uid']));
    }

    isLoading.value = false;
  }

  Future<void> createGroup(context) async {
    if (groupName.value != "") {
      isLoading.value = true;
      selectedContactList.add(LocalStorage.userId);
      DatabaseService(uid: LocalStorage.userId)
          .createConversation(
        contactsId: selectedContactList,
        groupName: groupName.value,
        uid: LocalStorage.userId,
        userName: LocalStorage.userName,
      )
          .whenComplete(() {
        isLoading.value = false;
      });
      Get.back();
      showSnackbar(context, Colors.green, "Group create successfully.");
    }
  }
}
