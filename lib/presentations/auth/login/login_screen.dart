import 'package:chat_app/presentations/auth/login/login_controller.dart';
import 'package:chat_app/utils/app_assets.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController _con = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () => _con.handleGoogleSignIn(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppAssets.google, height: 25),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Sign in with Google",
                    style: TextStyle(color: AppColors.blackColor, fontSize: 16),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
