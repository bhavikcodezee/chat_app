import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/presentations/chat_member/chat_member_controller.dart';
import 'package:chat_app/presentations/chat_member/components/drawer_screen.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMemberScreen extends StatelessWidget {
  ChatMemberScreen({super.key});
  final ChatMemberController _con = Get.put(ChatMemberController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => _con.scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(
              Icons.menu,
              color: AppColors.whiteColor,
            )),
        backgroundColor: AppColors.accentColor,
        title: const Text(
          "Chats",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: DrawerScreen(),
      body: Obx(
        () => _con.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                  strokeWidth: 5,
                ),
              )
            : chatMembersList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.contactScreen),
        elevation: 0,
        backgroundColor: AppColors.accentColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  Widget chatMembersList() {
    return StreamBuilder(
      stream: _con.conversationStrem,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ConversationTile(
                  userName: snapshot.data.docs[index][snapshot.data.docs[index]
                              ["sender_id"] ==
                          LocalStorage.userId.value.trim()
                      ? 'receiver_name'
                      : "sender_name"],
                  uid: snapshot.data.docs[index]["sender_id"],
                  converationId: snapshot.data.docs[index]["conversation_id"],
                  isGroup: snapshot.data.docs[index]["isGroup"],
                  memberList: snapshot.data.docs[index]["members"],
                );
              },
            );
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Widget noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.contactScreen),
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not started any conversation, tap on the add icon to create a converation or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final String userName;
  final String converationId;
  final bool isGroup;
  final List memberList;
  final String uid;
  const ConversationTile(
      {Key? key,
      required this.isGroup,
      required this.uid,
      required this.converationId,
      required this.memberList,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.toNamed(AppRoutes.chatScreen, arguments: [
        false,
        ContactModel(
          email: LocalStorage.userEmail.value,
          fullName: userName,
          profilepic: "",
          uid: uid,
          conversationID: converationId,
          isGroup: isGroup,
          memberList: memberList,
        )
      ]),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: AppColors.accentColor,
        child: Icon(
          isGroup ? Icons.group : Icons.person,
          color: AppColors.whiteColor,
        ),
      ),
      title: Text(
        userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text(
        "Available",
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
