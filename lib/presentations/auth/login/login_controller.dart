import 'dart:developer';

import 'package:chat_app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  //GOOGLE
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  GoogleSignInAccount? googleSignInAccount;

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
