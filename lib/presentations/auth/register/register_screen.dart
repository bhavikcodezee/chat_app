import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widget/app_button.dart';
import 'package:chat_app/widget/app_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/app_assets.dart';
import 'resgiter_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController _con = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green,
              Colors.green,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 40,
                color: AppColors.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                AppTextFiled(
                  hintText: "Full Name",
                  errorMessage: _con.fullNameError,
                  onChanged: (val) => _con.fullName.value = val,
                ),
                const SizedBox(height: 10),
                AppTextFiled(
                  hintText: "Email",
                  errorMessage: _con.emailError,
                  onChanged: (val) => _con.email.value = val,
                ),
                const SizedBox(height: 10),
                AppTextFiled(
                  hintText: "Password",
                  obscureText: true,
                  errorMessage: _con.passwordError,
                  onChanged: (val) => _con.password.value = val,
                ),
                const SizedBox(height: 30),
                AppButton(
                  width: Get.width * 0.5,
                  onPressed: () => _con.onRegister(),
                  text: "Sign up",
                  isLoading: _con.isLoading,
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: "Already have an account!",
                    children: [
                      TextSpan(
                        text: " Login now",
                        style: const TextStyle(
                          color: AppColors.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.back(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                  const SizedBox(width: 10),
                  const Text(
                    "Sign in with Google",
                    style:
                        TextStyle(color: AppColors.accentColor, fontSize: 16),
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
