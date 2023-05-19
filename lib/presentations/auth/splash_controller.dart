import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/local_storage.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(LocalStorage.isLogin
          ? AppRoutes.chatMemberScreen
          : AppRoutes.loginScreen);
    });
    super.onInit();
  }
}
