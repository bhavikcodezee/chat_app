import 'dart:developer';

import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/app_colors.dart';
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
    emailError.value = "";
    passwordError.value = "";
    if (email.value.trim().isEmpty) {
      emailError.value = "Please enter email";
      isValid.value = false;
    } else if (!email.value.isEmail) {
      emailError.value = "Please enter valid email";
      isValid.value = false;
    }

    if (password.trim().isEmpty) {
      passwordError.value = "Please enter password";
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
        UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
                email: email.value, password: password.value);
        log(userCredential.user.toString());
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email.value);

        LocalStorage.saveLocalData(
          isLoginFlag: true,
          name: snapshot.docs[0]['full_name'],
          email: email.value,
          userID: FirebaseAuth.instance.currentUser?.uid ?? "",
          image: snapshot.docs[0]['profile_pic'],
        );

        isLoading.value = false;
        await Get.offAllNamed(AppRoutes.chatMemberScreen);
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", e.message ?? "",
            backgroundColor: Colors.red, colorText: AppColors.whiteColor);
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
      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken:
              (await googleSignInAccount?.authentication)?.accessToken ?? "",
          idToken: (await googleSignInAccount?.authentication)?.idToken);
      firebaseAuth.signInWithCredential(oAuthCredential);
      LocalStorage.saveLocalData(
        isLoginFlag: true,
        name: googleSignInAccount?.displayName ?? "",
        email: googleSignInAccount?.email ?? "",
        userID: googleSignInAccount?.id ?? "",
        image: googleSignInAccount?.photoUrl ?? "",
      );
      if (googleSignInAccount != null) {
        Get.offNamed(AppRoutes.chatMemberScreen);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> handleGoogleSignOut() => _googleSignIn.signOut();
}
