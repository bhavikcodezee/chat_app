import 'dart:async';

import 'package:chat_app/model/contact_model.dart';
import 'package:chat_app/services/database_service.dart';
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
      timer = Timer(
        const Duration(milliseconds: 60 * 1000),
        () => endCall(docID.value),
      );
    }
    super.onInit();
  }

  @override
  void onClose() async {
    await FlutterRingtonePlayer.stop();
    timer?.cancel();
    super.onClose();
  }

  startCallTime() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      callTime.value++;
    });
  }

  Future<void> endCall(String docId) async {
    timer?.cancel();
    callTime.value = 0;
    await Wakelock.disable();
    await FlutterRingtonePlayer.stop();
    await DatabaseService().endCurrentCall(docId);
    Get.back();
  }
}
