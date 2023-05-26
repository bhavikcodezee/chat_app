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

  RxString firstName = "".obs;
  RxString firstNameError = "".obs;
  RxString lastName = "".obs;
  RxString lastNameError = "".obs;
  RxString email = "".obs;
  RxString emailError = "".obs;
  RxString password = "".obs;
  RxString passwordError = "".obs;
  RxBool isLoading = false.obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool validation() {
    RxBool isValid = true.obs;
    firstNameError.value = "";
    lastNameError.value = "";
    emailError.value = "";
    passwordError.value = "";

    if (firstName.trim().isEmpty) {
      firstNameError.value = "Please enter first name";
      isValid.value = false;
    } else if (firstName.value.length < 3) {
      firstNameError.value = "First name must be at least 3 characters long";
      isValid.value = false;
    }

    if (lastName.trim().isEmpty) {
      lastNameError.value = "Please enter last name";
      isValid.value = false;
    } else if (lastName.value.length < 3) {
      lastNameError.value = "Last name must be at least 3 characters long";
      isValid.value = false;
    }
    if (email.trim().isEmpty) {
      emailError.value = "Please enter email";
      isValid.value = false;
    } else if (!email.value.isEmail) {
      emailError.value = "Please enter valid email";
      isValid.value = false;
    }

    if (password.trim().isEmpty) {
      passwordError.value = "Please enter passsword";
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

          LocalStorage.saveLocalData(
            isLoginFlag: true,
            name: "${firstName.value} ${lastName.value}",
            email: email.value,
            userID: value.user?.uid ?? "",
            image: "",
          );
          Get.offAllNamed(AppRoutes.chatMemberScreen);
          return value.user;
        }));

        if (user != null) {
          await DatabaseService(uid: user.uid).updateUserData(
              fullName: "${firstName.value} ${lastName.value}",
              email: email.value,
              profilePic: "");
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
          image: "");

      if (googleSignInAccount != null) {
        Get.offNamed(AppRoutes.chatMemberScreen);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> handleGoogleSignOut() => _googleSignIn.signOut();
}
