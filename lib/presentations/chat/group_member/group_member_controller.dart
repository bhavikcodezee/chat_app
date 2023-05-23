import 'dart:convert';

import 'package:chat_app/model/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../services/database_service.dart';
import '../../../utils/local_storage.dart';

class GroupMemberController extends GetxController {
  RxBool isLoading = false.obs;
  List<ContactModel> contactList = [];
  ContactModel? contactModel;

  @override
  void onInit() {
    if (Get.arguments != null) {
      contactModel = Get.arguments;
      getGroupContacts();
    }
    super.onInit();
  }

  Future<void> getGroupContacts() async {
    isLoading.value = true;
    List<QueryDocumentSnapshot> queryDocumentList =
        (await DatabaseService(uid: LocalStorage.userId.value.trim())
                .getGroupMemberList(contactModel?.memberList ?? []))
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
          memberList: [],
          isGroup: false,
        ),
      );
    }

    isLoading.value = false;
  }
}
