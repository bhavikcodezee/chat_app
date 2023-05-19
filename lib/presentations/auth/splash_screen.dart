import 'package:chat_app/presentations/auth/splash_controller.dart';
import 'package:chat_app/utils/app_assets.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: RadialGradient(
          colors: [
            Colors.white,
            Colors.green,
          ],
        )),
        child: Image.asset(
          AppAssets.icon,
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
