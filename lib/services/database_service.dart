import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference conversationCollection =
      FirebaseFirestore.instance.collection("conversation");

//saving the user data
  Future updateUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "full_name": fullName,
      "email": email,
      "groups": [],
      "profile_pic": "",
      "uid": uid,
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();

    return snapshot;
  }

  //getting chats User data
  Future<QuerySnapshot> getContactList(String email) async {
    return userCollection.where("email", isNotEqualTo: email).get();
  }

  // create a group
  Future createConversation(
      {required String userName,
      required String uid,
      required String groupName,
      required List<String> contactsId}) async {
    DocumentReference documentReference = await conversationCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "isGroup": contactsId.isEmpty ? false : true,
      "admin": uid,
      "members": List<String>.from(contactsId),
      "conversation_id": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await documentReference.update({
      "conversation_id": documentReference.id,
    });

    Get.back();
    // DocumentReference userDocumentReference = userCollection.doc(uid);
    // return await userDocumentReference.update({
    //   "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"])
    // });
  }

  //getting messages
  Future getMessages(String conversationID) async {
    return conversationCollection
        .doc(conversationID)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // getAdmin
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = conversationCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
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

  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference =
        conversationCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }
}
