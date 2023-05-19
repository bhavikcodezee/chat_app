import 'dart:developer';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController _controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(_controller.groupName),
        backgroundColor: AppColors.accentColor,
        actions: [
          IconButton(
            onPressed: () {
              // Get.toNamed(
              //   AppRoutes.groupInfo,
              //   arguments: [
              //     _controller.groupId,
              //     _controller.groupName,
              //     _controller.admin,
              //   ],
              // );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Stack(
        children: [
          chatMessage(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: _controller.messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessage() {
    return StreamBuilder(
      stream: _controller.chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                physics: const ClampingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  log(snapshot.data.docs[index]["sender"]);

                  if (!_controller.senderList
                      .contains(snapshot.data.docs[index]["sender"])) {
                    _controller.senderList
                        .add(snapshot.data.docs[index]["sender"]);
                  }

                  log("lenght${_controller.senderList.length}");
                  return MessageTile(
                    message: snapshot.data.docs[index]["message"],
                    sender: snapshot.data.docs[index]["sender"],
                    sentByMe: _controller.userName ==
                        snapshot.data.docs[index]["sender"],
                    index: index,
                    sanderList: _controller.senderList,
                  );
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (_controller.messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": _controller.messageController.text,
        "sender": _controller.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(_controller.groupId, chatMessageMap);
      _controller.messageController.clear();
    }
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
    log(sender.length.toString());
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 4,
        // left: sentByMe ? 0 : 20,
        // right: sentByMe ? 20 : 0,
      ),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
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
                  // topRight: Radius.circular(10),
                )
              : const BorderRadius.only(
                  // topLeft: Radius.circular(10),
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
            SizedBox(
              height: sentByMe ? 0 : 2,
            ),
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
