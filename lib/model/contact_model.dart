class ContactModel {
  String email;
  String fullName;
  String profilepic;
  String uid;
  String conversationID;
  bool isGroup;
  List memberList;
  ContactModel({
    required this.email,
    required this.fullName,
    required this.profilepic,
    required this.uid,
    required this.conversationID,
    required this.isGroup,
    required this.memberList,
  });
}
