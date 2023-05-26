import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Pref {
  static String isLogin = "IS_LOGIN";
  static String userName = "USER_NAME";
  static String userEmail = "USER_EMAIL";
  static String userImage = "USER_IMAGE";
  static String userId = "USER_ID";
}

class LocalStorage {
  static GetStorage gs = GetStorage();
  static RxBool isLogin = false.obs;
  static RxString userName = "".obs;
  static RxString userEmail = "".obs;
  static RxString userImage = "".obs;
  static RxString userId = "".obs;

  static saveLocalData(
      {required bool isLoginFlag,
      required String name,
      required String email,
      required String image,
      required String userID}) {
    gs.write(Pref.isLogin, isLoginFlag);
    gs.write(Pref.userName, name);
    gs.write(Pref.userEmail, email);
    gs.write(Pref.userImage, image);
    gs.write(Pref.userId, userID);
    isLogin.value = gs.read(Pref.isLogin) ?? false;
    userEmail.value = gs.read(Pref.userEmail) ?? "";
    userName.value = gs.read(Pref.userName) ?? "";
    userImage.value = gs.read(Pref.userImage) ?? "";
    userId.value = gs.read(Pref.userId) ?? "";
  }

  static loadLocalData() {
    isLogin.value = gs.read(Pref.isLogin) ?? false;
    userEmail.value = gs.read(Pref.userEmail) ?? "";
    userName.value = gs.read(Pref.userName) ?? "";
    userImage.value = gs.read(Pref.userImage) ?? "";
    userId.value = gs.read(Pref.userId) ?? "";
  }

  static logout() {
    gs.erase();
    FirebaseAuth.instance.signOut();
  }
}
