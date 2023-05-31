import 'package:chat_app/presentations/auth/login/login_screen.dart';
import 'package:chat_app/presentations/auth/register/register_screen.dart';
import 'package:chat_app/presentations/auth/splash_screen.dart';
import 'package:chat_app/presentations/auth/verification/verification_screen.dart';
import 'package:chat_app/presentations/chat/chat_screen.dart';
import 'package:chat_app/presentations/chat/group_member/group_member_screen.dart';
import 'package:chat_app/presentations/chat_member/chat_member_screen.dart';
import 'package:chat_app/presentations/contact/contact_screen.dart';
import 'package:chat_app/presentations/edit_profile/edit_profile_screen.dart';
import 'package:chat_app/presentations/pickup/pickup_screen.dart';
import 'package:chat_app/presentations/video/video_screen.dart';
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
      name: AppRoutes.verificationScreen,
      page: () => VerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.chatMemberScreen,
      page: () => ChatMemberScreen(),
    ),
    GetPage(
      name: AppRoutes.chatScreen,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.registerScreen,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.contactScreen,
      page: () => ContactScreen(),
    ),
    GetPage(
      name: AppRoutes.groupMemberScreen,
      page: () => GroupMemberScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () => EditProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.videoScreen,
      page: () => VideoScreen(),
    ),
    GetPage(
      name: AppRoutes.pickupScreen,
      page: () => PickUpScreen(isForOutGoing: false, docId: ""),
    ),
  ];
}
