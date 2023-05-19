import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class Pref {
  static String isLogin = "IS_LOGIN";
  static String userName = "USER_NAME";
  static String userEmail = "USER_EMAIL";
  static String userId = "USER_ID";
}

class LocalStorage {
  static GetStorage gs = GetStorage();

  static bool isLogin = false;
  static String userName = "";
  static String userEmail = "";
  static String userId = "";

  static saveLocalData(
      {required bool isLogin,
      required String name,
      required String email,
      required String userID}) {
    gs.write(Pref.isLogin, isLogin);
    gs.write(Pref.userName, name);
    gs.write(Pref.userEmail, email);
    gs.write(Pref.userId, userID);
    isLogin = gs.read(Pref.isLogin) ?? false;
    userEmail = gs.read(Pref.userEmail) ?? "";
    userName = gs.read(Pref.userName) ?? "";
    userId = gs.read(Pref.userId) ?? "";
  }

  static loadLocalData() {
    isLogin = gs.read(Pref.isLogin) ?? false;
    userEmail = gs.read(Pref.userEmail) ?? "";
    userName = gs.read(Pref.userName) ?? "";
    userId = gs.read(Pref.userId) ?? "";
  }

  static logout() {
    gs.erase();
    FirebaseAuth.instance.signOut();
  }
}
