import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  final String appId = "67b3ed8c2c3f41e88fd9b768f9988cc6";
  final String token =
      "007eJxTYPBrC85mmFbIG5/IYMq9sN4q5c9xbs+tl156Fisl5N44wqXAYGaeZJyaYpFslGycZmKYamGRlmKZZG5mkWZpaWGRnGwW8KospSGQkYFr20MWRgYIBPGZGSIioxgYAG0NHQg=";
  RxString channelId = "".obs;
  RxString docId = "".obs;
  late final RtcEngine engine;
  RxBool isMuted = false.obs;
  RxBool switchCamera = false.obs;
  RxBool isUseFlutterTexture = false.obs;
  RxBool isUseAndroidSurfaceView = false.obs;
  RxList<int> remoteUid = <int>[].obs;
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;

  @override
  void onInit() async {
    await _initEngine();
    super.onInit();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  Future<void> _initEngine() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('==============[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        log('------------------------[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        remoteUid.add(rUid);
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        log('[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        remoteUid.removeWhere((element) => element == rUid);
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        remoteUid.clear();
      },
    ));
    await engine.enableVideo();
    await joinChannel();
  }

  void onToggleMute() {
    isMuted.toggle();
    engine.muteLocalAudioStream(isMuted.value);
  }

  Future<void> joinChannel() async {
    await engine.joinChannel(
      token: token,
      channelId: channelId.value,
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  void onCallEnd(BuildContext context) {
    Get.back();
    DatabaseService().endCurrentCall(docId.value);
  }

  Future<void> switchCameraFn() async {
    await engine.switchCamera();
    switchCamera.toggle();
  }

  Future<void> _dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }
}
