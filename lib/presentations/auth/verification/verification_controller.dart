import 'package:chat_app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  String phone = '+91${GetUtils.removeAllWhitespace(Get.arguments[0])}';
  String verificationId = Get.arguments[1];

  Future<void> verifyOTP(String code) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offAllNamed(AppRoutes.chatMemberScreen);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify OTP: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
