import 'dart:developer';

import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? googleSignInAccount;

  RxString fullName = "".obs;
  RxString fullNameError = "".obs;
  RxString email = "".obs;
  RxString emailError = "".obs;
  RxString password = "".obs;
  RxString passwordError = "".obs;
  RxBool isLoading = false.obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool validation() {
    RxBool isValid = true.obs;
    fullNameError.value = "";
    emailError.value = "";
    passwordError.value = "";

    if (fullName.isEmpty) {
      fullNameError.value = "Enter valid Full Name";
      isValid.value = false;
    } else if (fullName.value.length < 3) {
      fullNameError.value = "Full Name must be at least 3 characters long";
      isValid.value = false;
    }

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

  Future<void> onRegister() async {
    if (validation()) {
      isLoading.value = true;
      try {
        User? user = (await firebaseAuth
            .createUserWithEmailAndPassword(
                email: email.value, password: password.value)
            .then((value) async {
          isLoading.value = false;
          await LocalStorage.saveUserName(fullName.value);
          await LocalStorage.saveEmailName(email.value);
          await LocalStorage.saveUserLoggedInStatus(true);
          Get.offAllNamed(AppRoutes.chatMemberScreen);
          return value.user;
        }));

        if (user != null) {
          await DatabaseService(uid: user.uid)
              .updateUserData(fullName.value, email.value);
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        log(e.toString());
      }
    }
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
