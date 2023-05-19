import 'dart:developer';

import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/local_storage.dart';

class LoginController extends GetxController {
  //GOOGLE
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? googleSignInAccount;

  RxString email = "".obs;
  RxString emailError = "".obs;

  RxString password = "".obs;
  RxString passwordError = "".obs;

  RxBool isLoading = false.obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool validation() {
    RxBool isValid = true.obs;

    if (!email.value.isEmail) {
      emailError.value = "Enter valid Email";
      isValid.value = false;
    }

    if (password.isEmpty) {
      passwordError.value = "Enter valid Password";
      isValid.value = false;
    } else if (password.value.length < 8) {
      passwordError.value = "Password must be at least 8 characters long";
      isValid.value = false;
    }

    return isValid.value;
  }

  Future<void> onLogin() async {
    if (validation()) {
      isLoading.value = true;
      try {
        User user = (await firebaseAuth
            .signInWithEmailAndPassword(
                email: email.value, password: password.value)
            .then((value) async {
          isLoading.value = false;

          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email.value);

          await LocalStorage.saveUserName(snapshot.docs[0]['fullName']);
          await LocalStorage.saveEmailName(email.value);
          await LocalStorage.saveUserLoggedInStatus(true);

          await Get.offAllNamed(AppRoutes.chatMemberScreen);
          return value.user!;
        }));
        log(user.toString());
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        log(e.toString());
      }
    }
  }

  Future<void> sendOTP(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar(
          'Error',
          'Failed to send OTP: ${e.message}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Get.toNamed(AppRoutes.verificationScreen,
            arguments: [phone, verificationId]);

        log("phone $phone");
        log("verificationId $verificationId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> handleGoogleSignIn() async {
    try {
      googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        Get.offNamed(AppRoutes.chatMemberScreen, arguments: {
          "displayName": googleSignInAccount?.displayName ?? "",
          "email": googleSignInAccount?.email ?? "",
          "id": googleSignInAccount?.id ?? "",
          "type": "google",
        });
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> handleGoogleSignOut() => _googleSignIn.signOut();
}
