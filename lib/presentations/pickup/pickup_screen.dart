import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/presentations/pickup/pickup_controller.dart';
import 'package:chat_app/presentations/video/video_controller.dart';
import 'package:chat_app/presentations/video/video_screen.dart';
import 'package:chat_app/services/check_network_connectivity.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PickUpScreen extends StatelessWidget {
  final bool isForOutGoing;
  final String docId;
  PickUpScreen({
    super.key,
    this.isForOutGoing = false,
    required this.docId,
  });
  final PickUpcontroller _con = Get.put(PickUpcontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Object?>>(
          stream: DatabaseService()
              .listenToAcceptCall(docId.isEmpty ? _con.docID.value : docId),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data?.docs != null &&
                snapshot.data!.docs.isNotEmpty &&
                snapshot.data!.docs[0]['connected'] &&
                snapshot.data!.docs[0]['type'] == "video_call") {
              Get.put(VideoController()).channelId.value =
                  snapshot.data!.docs[0]['channel_Id'];
              Get.put(VideoController()).docId.value =
                  docId.isEmpty ? _con.docID.value : docId;
              _con.timer?.cancel();
              _con.callTime.value = 0;
              return VideoScreen();
            } else {
              if (snapshot.data?.docs != null &&
                  snapshot.data!.docs.isNotEmpty &&
                  snapshot.data!.docs[0]['connected'] &&
                  snapshot.data!.docs[0]['type'] == "call") {
                _con.type.value = snapshot.data!.docs[0]['type'];
                _con.channelId.value = snapshot.data!.docs[0]['channel_Id'];
                // if (_con.callTime.value == 0) {
                //   _con.startCallTime();
                // }
                //TODO Timer issue remaining
                if (_con.engine == null) {
                  _con.initEngine();
                }
              } else {
                _con.timer?.cancel();
                _con.callTime.value = 0;
              }
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.2, 0.6],
                    colors: [
                      AppColors.accentColor,
                      AppColors.primaryColor.withOpacity(0.8)
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Obx(
                      () => Text(
                        _con.callTime.value > 0
                            ? "${_con.callTime.value ~/ 60}:${_con.callTime.value % 60}"
                            : isForOutGoing
                                ? "Incoming Call..."
                                : "Outgoing Call...",
                        style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _getImageUrlWidget(),
                    const SizedBox(height: 30),
                    Text(
                      isForOutGoing
                          ? (snapshot.data?.docs != null &&
                                  snapshot.data!.docs.isNotEmpty)
                              ? snapshot.data!.docs[0]['sender_name']
                              : ""
                          : _con.contactModel?.fullName ?? "",
                      style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (snapshot.data?.docs != null &&
                            snapshot.data!.docs.isNotEmpty &&
                            snapshot.data!.docs[0]['connected'] &&
                            snapshot.data!.docs[0]['type'] == "call")
                          Obx(
                            () => RawMaterialButton(
                              onPressed: _con.onToggleMute,
                              shape: const CircleBorder(),
                              elevation: 2.0,
                              fillColor: _con.isMuted.value
                                  ? Colors.blueAccent
                                  : Colors.white,
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                _con.isMuted.value ? Icons.mic_off : Icons.mic,
                                color: _con.isMuted.value
                                    ? Colors.white
                                    : Colors.blueAccent,
                                size: 20.0,
                              ),
                            ),
                          ),
                        _callingButtonWidget(context, false),
                        if (snapshot.data?.docs != null &&
                            snapshot.data!.docs.isNotEmpty &&
                            !snapshot.data!.docs[0]['connected'])
                          isForOutGoing
                              ? _callingButtonWidget(context, true)
                              : const SizedBox(),
                        if (snapshot.data?.docs != null &&
                            snapshot.data!.docs.isNotEmpty &&
                            snapshot.data!.docs[0]['connected'] &&
                            snapshot.data!.docs[0]['type'] == "call")
                          Obx(
                            () => RawMaterialButton(
                              onPressed: _con.switchSpeakerphone,
                              shape: const CircleBorder(),
                              elevation: 2.0,
                              fillColor: _con.enableSpeakerphone.value
                                  ? Colors.blueAccent
                                  : Colors.white,
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                _con.enableSpeakerphone.value
                                    ? Icons.volume_up
                                    : Icons.volume_mute,
                                color: _con.enableSpeakerphone.value
                                    ? Colors.white
                                    : Colors.blueAccent,
                                size: 20.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  //To Display Profile Image Of User
  _getImageUrlWidget() => ClipOval(
          child: CircleAvatar(
        backgroundColor: AppColors.whiteColor,
        radius: Get.width * 0.2,
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.accentColor,
                    ),
                  ),
                ),
            errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
            imageUrl: _con.contactModel?.profilepic ?? ""),
      ));

  _callingButtonWidget(BuildContext context, bool isCall) => RawMaterialButton(
        onPressed: () {
          if (isCall) {
            _con.timer?.cancel();
            pickUpCallPressed(context);
          } else {
            _con.endCall(docId.isEmpty ? _con.docID.value : docId);
          }
        },
        shape: const CircleBorder(),
        elevation: 2.0,
        fillColor: isCall ? Colors.green : Colors.redAccent,
        padding: const EdgeInsets.all(20),
        child: Icon(
          isCall ? Icons.call : Icons.call_end,
          color: Colors.white,
          size: 25,
        ),
      );

  void pickUpCallPressed(context) async {
    if (await Permission.camera.request().isGranted) {
      if (await Permission.microphone.request().isGranted) {
        FlutterRingtonePlayer.stop();
        if (await checkNetworkConnection(context)) {
          DatabaseService().acceptCallToFirestore(docId: docId);
        }
      }
    }
  }
}
