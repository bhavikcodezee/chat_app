import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class Pref {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String useNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
}

class LocalStorage {
  static GetStorage gs = GetStorage();

  static bool userLoggedInKey = false;
  static String useNameKey = "";
  static String userEmailKey = "";

  static saveUserLoggedInStatus(bool value) async {
    gs.write(Pref.userLoggedInKey, value);
    userLoggedInKey = gs.read(Pref.userLoggedInKey);
    loadLocalData();
  }

  static saveUserName(String value) async {
    gs.write(Pref.useNameKey, value);
    useNameKey = gs.read(Pref.useNameKey);
    loadLocalData();
  }

  static saveEmailName(String value) async {
    gs.write(Pref.userEmailKey, value);
    userEmailKey = gs.read(Pref.userEmailKey);
    loadLocalData();
  }

  // static getUserLoggedInStatus(value) async {
  //   GetStorage gs = GetStorage();
  //   gs.write(Pref.userLoggedInKey, value);
  //   userLoggedInKey = gs.read(Pref.userLoggedInKey);
  //   loadLocalData();
  // }

  static loadLocalData() {
    userLoggedInKey = gs.read(Pref.userLoggedInKey) ?? false;
    userEmailKey = gs.read(Pref.userEmailKey) ?? "";
    useNameKey = gs.read(Pref.useNameKey) ?? "";
  }

  static logout() {
    gs.erase();
    FirebaseAuth.instance.signOut();
  }
}
