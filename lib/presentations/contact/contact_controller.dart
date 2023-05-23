import 'dart:convert';

import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  RxBool isLoading = false.obs;
  List<ContactModel> contactList = [];
  RxList<String> selectedContactList = <String>[].obs;
  RxString groupName = "".obs;
  RxBool isGroup = false.obs;
  RxBool isCreateConversation = false.obs;
  RxBool isCreateGroup = false.obs;

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
        (await DatabaseService(uid: LocalStorage.userId.value.trim())
                .getContactList(LocalStorage.userEmail.value.trim()))
            .docs;

    for (QueryDocumentSnapshot queryDocumentSnapshot in queryDocumentList) {
      var resData = jsonDecode(jsonEncode((queryDocumentSnapshot.data())));
      contactList.add(
        ContactModel(
          email: resData['email'],
          fullName: resData['full_name'],
          profilepic: "",
          uid: resData['uid'],
          conversationID: "",
          isGroup: false,
          memberList: [],
        ),
      );
    }

    isLoading.value = false;
  }

  Future<void> createConversation(context, ContactModel contactModel) async {
    isCreateConversation.value = true;

    QuerySnapshot queryDocumentList =
        await DatabaseService(uid: LocalStorage.userId.value.trim())
            .findConversation(
      receiverId: contactModel.uid,
      senderId: LocalStorage.userId.value.trim(),
    );
    if (queryDocumentList.docs.isEmpty) {
      String conversationId =
          await DatabaseService(uid: LocalStorage.userId.value.trim())
              .createConversation(
        contactsId: [LocalStorage.userId.value.trim(), contactModel.uid],
        sendername: LocalStorage.userName.value,
        receivername: contactModel.fullName,
        sid: LocalStorage.userId.value.trim(),
        rid: contactModel.uid,
        isGroup: false,
      );
      contactModel.conversationID = conversationId;
    } else {
      contactModel.conversationID = queryDocumentList.docs[0].id;
    }
    Get.toNamed(AppRoutes.chatScreen, arguments: [true, contactModel]);
    isCreateConversation.value = false;
  }

  Future<void> createGroup(context) async {
    isCreateGroup.value = true;
    if (groupName.value.trim().isNotEmpty) {
      selectedContactList.add(LocalStorage.userId.value.trim());
      await DatabaseService(uid: LocalStorage.userId.value.trim())
          .createConversation(
        contactsId: selectedContactList,
        sendername: groupName.value,
        receivername: groupName.value,
        sid: LocalStorage.userId.value.trim(),
        rid: LocalStorage.userId.value.trim(),
        isGroup: true,
      );
      Get.back();
    }
    isCreateGroup.value = false;
  }
}
