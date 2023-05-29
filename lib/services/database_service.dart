import 'dart:async';

import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection("conversation");

  final CollectionReference callsCollection =
      FirebaseFirestore.instance.collection("call");

  Stream<QuerySnapshot<Object?>> listenToInComingCall() {
    return callsCollection
        .where('receiver_id', isEqualTo: LocalStorage.userId.value)
        .snapshots();
  }

  Future<void> postCallToFirestore(
      {required ContactModel contactModel, required String channelId}) {
    return callsCollection.doc(LocalStorage.userId.value).set({
      "receiver_id": contactModel.uid,
      "sender_id": LocalStorage.userId.value,
      "sender_image": contactModel.profilepic,
      "channel_Id": channelId
    });
  }

  Future<void> endCurrentCall() {
    return callsCollection.doc().delete();
  }

  //SAVE/UPDATE USER DATA
  Future updateUserData({
    required String fullName,
    required String email,
    String? profilePic,
  }) async {
    return await userCollection.doc(uid).set({
      "full_name": fullName,
      "email": email,
      "profile_pic": profilePic,
      "uid": uid,
    });
  }

  //GET USER DATA
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();

    return snapshot;
  }

  //getting chats User data
  Future<QuerySnapshot> getContactList(String email) async {
    return userCollection.where("email", isNotEqualTo: email).get();
  }

  //getting group members
  Future<QuerySnapshot> getGroupMemberList(List memberList) async {
    return userCollection.where("uid", whereIn: memberList).get();
  }

  //getting get conversations
  Future<Stream> getConversationList(String adminId) async {
    return conversationCollection
        .where("members", arrayContains: adminId)
        .snapshots();
  }

  //Group filter in chat members
  Future<Stream> getConversationGroupList(String userId) async {
    return conversationCollection
        .where(
          Filter.and(
            Filter("members", arrayContains: userId),
            Filter("isGroup", isEqualTo: true),
          ),
        )
        .snapshots();
  }

  //Find Conversation
  Future<QuerySnapshot<Object?>> findConversation(
      {required String senderId, required String receiverId}) async {
    return conversationCollection
        .where(
          Filter.and(
            Filter("receiver_id", whereIn: [senderId, receiverId]),
            Filter("sender_id", whereIn: [senderId, receiverId]),
            Filter("isGroup", isEqualTo: false),
          ),
        )
        .get();
  }

  // create a group
  Future<String> createConversation({
    required String sid,
    required String rid,
    required String sendername,
    required String receivername,
    required bool isGroup,
    required List<String> contactsId,
  }) async {
    DocumentReference documentReference = await conversationCollection.add({
      "sender_name": sendername,
      "receiver_name": receivername,
      "icon": "",
      "isGroup": isGroup,
      "sender_id": sid,
      "receiver_id": rid,
      "members": List<String>.from(contactsId),
      "conversation_id": "",
    });

    await documentReference.update({"conversation_id": documentReference.id});
    if (!isGroup) {
      await userCollection.doc(uid).update({"is_conversation": true});
    }
    Get.back();
    return documentReference.id;
  }

  //getting messages
  Future getMessages(String conversationID) async {
    return conversationCollection
        .doc(conversationID)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // get group member
  Future getGroupMember(groupId) async {
    return conversationCollection.doc(groupId).snapshots();
  }

  // send message
  Future<void> sendMessage(
      String conversationId, Map<String, dynamic> chatMessageData) async {
    conversationCollection
        .doc(conversationId)
        .collection("messages")
        .add(chatMessageData);
  }
}
