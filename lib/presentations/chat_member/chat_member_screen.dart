import 'package:chat_app/presentations/chat_member/chat_member_controller.dart';
import 'package:chat_app/presentations/chat_member/components/drawer_screen.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/app_colors.dart';
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
          "Chat",
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
    return Obx(
      () => _con.isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : _con.userList.isEmpty
              ? const Center(child: Text("No conversation found"))
              : ListView.builder(
                  itemCount: _con.userList.length,
                  itemBuilder: (context, index) {
                    return const SizedBox();
                    // return GroupTile(
                    //     groupId:
                    //         _con.getId(snapshot.data['groups'][reverseIndex]),
                    //     groupName:
                    //         _con.getName(snapshot.data['groups'][reverseIndex]),
                    //     userName: snapshot.data['fullName']);
                  },
                ),
    );
    // return StreamBuilder(
    //   stream: _con.stream,
    //   builder: (context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasData) {
    //       if (snapshot.data['groups'] != null) {
    //         if (snapshot.data['groups'].length != 0) {
    //           return ListView.builder(
    //             itemCount: snapshot.data['groups'].length,
    //             itemBuilder: (context, index) {
    //               int reverseIndex = snapshot.data['groups'].length - index - 1;
    //               return GroupTile(
    //                   groupId:
    //                       _con.getId(snapshot.data['groups'][reverseIndex]),
    //                   groupName:
    //                       _con.getName(snapshot.data['groups'][reverseIndex]),
    //                   userName: snapshot.data['fullName']);
    //             },
    //           );
    //         } else {
    //           return noGroupWidget();
    //         }
    //       } else {
    //         return noGroupWidget();
    //       }
    //     } else {
    //       return const Center(
    //         child: CircularProgressIndicator.adaptive(),
    //       );
    //     }
    //   },
    // );
  }

  Widget noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            // onTap: () => createGroupDialog(Get.context!),
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
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.chatScreen,
            arguments: [groupId, groupName, userName]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.accentColor,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as $userName",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
