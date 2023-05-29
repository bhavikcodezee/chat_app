import 'package:chat_app/presentations/chat/chat_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:chat_app/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final ChatController _con = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: _con.contactModel?.fullName ?? "", actions: [
        _con.contactModel?.isGroup ?? false
            ? IconButton(
                onPressed: () => Get.toNamed(AppRoutes.groupMemberScreen,
                    arguments: _con.contactModel),
                icon: const Icon(
                  Icons.info,
                  color: AppColors.whiteColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async => await _con.onJoin(),
                    icon: const Icon(
                      Icons.phone,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () async => await _con.onJoin(),
                    icon: const Icon(
                      Icons.video_call,
                      color: AppColors.whiteColor,
                    ),
                  )
                ],
              )
      ]),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        color: AppColors.primaryColor,
        child: Row(children: [
          Expanded(
              child: TextFormField(
            controller: _con.messageController,
            style: const TextStyle(color: Colors.white),
            cursorColor: AppColors.accentColor,
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
      body: Obx(() => _con.isLoading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppColors.accentColor,
                strokeWidth: 5,
              ),
            )
          : messages()),
    );
  }

  Widget messages() {
    return StreamBuilder(
      stream: _con.messages,
      builder: (context, AsyncSnapshot snapshot) {
        return _con.isLoading.value &&
                snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.accentColor,
                  strokeWidth: 5,
                ),
              )
            : snapshot.hasData
                ? snapshot.data.docs.isEmpty
                    ? const Center(
                        child: Text("No messages available"),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100, top: 10),
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return MessageTile(
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index][
                                (_con.contactModel?.isGroup ?? false)
                                    ? 'sender_name'
                                    : 'receiver_name'],
                            sentByMe: snapshot.data.docs[index]['sender_id'] ==
                                LocalStorage.userId.value.trim(),
                            time: Jiffy.parse(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            snapshot.data.docs[index]['time'])
                                        .toString())
                                .fromNow()
                                .toString(),
                          );
                        },
                      )
                : const Center(
                    child: Text("No messages available"),
                  );
      },
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String time;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: Get.width * 0.5),
          margin: sentByMe
              ? const EdgeInsets.only(left: 20, top: 4)
              : const EdgeInsets.only(right: 20, bottom: 4),
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
            color: sentByMe ? AppColors.accentColor : AppColors.primaryColor,
          ),
          child: Column(
            crossAxisAlignment:
                sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              sentByMe
                  ? const SizedBox()
                  : Text(
                      sender.capitalizeFirst.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentColor,
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
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
