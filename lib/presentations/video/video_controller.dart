import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoController extends GetxController {
  final String appId = "67b3ed8c2c3f41e88fd9b768f9988cc6";
  final String token = "968a53f68a6841f5960f99e7972d51b9";
  RxString channelId = "".obs;
  late final RtcEngine engine;
  RxBool isJoined = false.obs;
  RxBool isMuted = false.obs;
  RxBool switchCamera = false.obs;
  RxBool isUseFlutterTexture = false.obs;
  RxBool isUseAndroidSurfaceView = false.obs;
  Set<int> remoteUid = {};
  ChannelProfileType channelProfileType =
      ChannelProfileType.channelProfileCommunication;

  @override
  void onInit() {
    if (Get.arguments != null) {
      channelId = Get.arguments;
      _initEngine();
    }
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
        log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');

        isJoined.value = true;
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        log('[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        remoteUid.add(rUid);
      },
      onUserOffline:
          (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        log('[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        remoteUid.removeWhere((element) => element == rUid);
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        isJoined.value = false;
        remoteUid.clear();
      },
    ));

    await engine.enableVideo();
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
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
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
