import 'package:chat_app/presentations/auth/login/login_screen.dart';
import 'package:chat_app/presentations/auth/splash_screen.dart';
import 'package:chat_app/presentations/chat/chat_screen.dart';
import 'package:chat_app/presentations/chat_member/chat_member_screen.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.chatMemberScreen,
      page: () => const ChatMemberScreen(),
    ),
    GetPage(
      name: AppRoutes.chatScreen,
      page: () => const ChatScreen(),
    ),
  ];
}
