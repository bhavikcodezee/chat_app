import 'dart:async';

import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:wakelock/wakelock.dart';

class PickUpcontroller extends GetxController {
  RxBool isForOutGoing = false.obs;
  Timer? timer;
  ContactModel? contactModel;
  RxString channelName = "XYZ".obs;

  @override
  void onInit() async {
    if (Get.arguments != null) {
      contactModel = Get.arguments;
      await DatabaseService().postCallToFirestore(
          contactModel: contactModel!, channelId: channelName.value);
    }
    await Wakelock.enable();
    await FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.electronic,
        looping: true,
        volume: 0.5,
        asAlarm: false);
    timer = Timer(const Duration(milliseconds: 60 * 1000), endCall);
    super.onInit();
  }

  @override
  void onClose() async {
    await FlutterRingtonePlayer.stop();
    timer?.cancel();
    super.onClose();
  }

  Future<void> endCall() async {
    await Wakelock.disable();
    await FlutterRingtonePlayer.stop();
    await DatabaseService().endCurrentCall();
    Get.back();
  }
}
