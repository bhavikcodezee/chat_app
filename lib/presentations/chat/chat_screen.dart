import 'package:chat_app/presentations/chat/chat_controller.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController _con = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
          ),
        ),
        title: const Text(
          "_con.groupName",
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.accentColor,
        actions: [
          IconButton(
            onPressed: () {
              // Get.toNamed(
              //   AppRoutes.groupInfo,
              //   arguments: [
              //     _con.groupId,
              //     _con.groupName,
              //     _con.admin,
              //   ],
              // );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        color: Colors.grey[700],
        child: Row(children: [
          Expanded(
              child: TextFormField(
            controller: _con.messageController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Send a message...",
              hintStyle: TextStyle(color: Colors.white, fontSize: 16),
              border: InputBorder.none,
            ),
          )),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _con.sendMessage(),
            child: Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                  color: AppColors.accentColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ]),
      ),
      body: messages(),
    );
  }

  Widget messages() {
    return StreamBuilder(
      stream: _con.messages,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  if (!_con.senderList
                      .contains(snapshot.data.docs[index]["sender"])) {
                    _con.senderList.add(snapshot.data.docs[index]["sender"]);
                  }
                  return MessageTile(
                    message: snapshot.data.docs[index]["message"],
                    sender: snapshot.data.docs[index]["sender"],
                    sentByMe: true, //TODO
                    index: index,
                    sanderList: _con.senderList,
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                  strokeWidth: 5,
                ),
              );
      },
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final int index;
  final List sanderList;
  final List colorList = [Colors.red, Colors.green, Colors.black];

  MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.index,
    required this.sanderList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: Get.width * 0.65),
        margin: sentByMe
            ? const EdgeInsets.only(left: 20)
            : const EdgeInsets.only(right: 20),
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
        decoration: BoxDecoration(
          borderRadius: sentByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
          color: sentByMe ? AppColors.accentColor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sentByMe
                ? const SizedBox()
                : Text(
                    sender.capitalizeFirst.toString(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      letterSpacing: -0.5,
                    ),
                  ),
            SizedBox(height: sentByMe ? 0 : 2),
            Text(
              message,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
