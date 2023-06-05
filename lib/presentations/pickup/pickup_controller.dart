import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/app_config.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

class PickUpcontroller extends GetxController {
  Timer? timer;
  ContactModel? contactModel;
  RxString channelId = "XYZ".obs;
  RxString docID = "".obs;
  RxString type = "".obs;
  RxInt callTime = 0.obs;
  //---------------
  RtcEngine? engine;
  RxBool isMuted = false.obs;
  RxBool enableSpeakerphone = false.obs;
  final ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;

  @override
  void onInit() async {
    if (Get.parameters['type'] != null) {
      type.value = Get.parameters['type'] ?? "";
    }
    if (Get.arguments != null) {
      contactModel = Get.arguments;
      docID.value = await DatabaseService().postCallToFirestore(
        contactModel: contactModel!,
        channelId: channelId.value,
        type: type.value,
      );
    }
    await Wakelock.enable();
    await FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.electronic,
        looping: true,
        volume: 0.5,
        asAlarm: false);
    if (type.value == "video_call") {
      Timer(
        const Duration(seconds: 60),
        () => endCall(docId: docID.value),
      );
    }
    super.onInit();
  }

  @override
  void onClose() async {
    await FlutterRingtonePlayer.stop();
    _dispose();
    super.onClose();
  }

  Future<void> endCall({String? docId}) async {
    if (type.value == "call") {
      await _dispose();
    }
    timer?.cancel();
    callTime.value = 0;
    await Wakelock.disable();
    await FlutterRingtonePlayer.stop();
    if (docId != null) {
      await DatabaseService().endCurrentCall(docId);
    }
    Get.back();
  }

  Future<void> _dispose() async {
    if (engine != null) {
      await engine?.leaveChannel();
      await engine?.release();
      enableSpeakerphone.value = false;
    }
  }

  Future<void> initEngine() async {
    engine = createAgoraRtcEngine();
    await engine?.initialize(const RtcEngineContext(
      appId: AppConfig.appId,
    ));

    engine?.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        log('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        log('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        log('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
      },
    ));

    await engine?.enableAudio();
    await engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine?.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    joinChannel();
  }

  Future<void> joinChannel() async {
    await engine?.joinChannel(
      token: AppConfig.token,
      channelId: channelId.value,
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> onToggleMute() async {
    isMuted.toggle();
    await engine?.muteLocalAudioStream(isMuted.value);
  }

  Future<void> switchSpeakerphone() async {
    enableSpeakerphone.toggle();
    await engine?.setEnableSpeakerphone(enableSpeakerphone.value);
  }

  void startCallTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      callTime.value++;
    });
  }
}
