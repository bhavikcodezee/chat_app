import 'package:chat_app/presentations/auth/login/login_controller.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/utils/app_assets.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/widget/app_button.dart';
import 'package:chat_app/widget/app_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController _con = Get.put(LoginController());
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
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 40,
                color: AppColors.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                AppTextFiled(
                  hintText: "Email",
                  errorMessage: _con.emailError,
                  onChanged: (val) => _con.email.value = val,
                ),
                const SizedBox(height: 15),
                AppTextFiled(
                  hintText: "Password",
                  obscureText: true,
                  errorMessage: _con.passwordError,
                  onChanged: (val) => _con.password.value = val,
                ),
                const SizedBox(height: 30),
                AppButton(
                  onPressed: () => _con.onLogin(),
                  width: Get.width * 0.5,
                  text: "Sign In",
                  isLoading: _con.isLoading,
                ),
                TextButton(
                  onPressed: () => _con.sendOTP("+91 9824871769"),
                  child: const Text(
                    "Forgot password",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account?",
                    children: [
                      TextSpan(
                        text: " Sign Up",
                        style: const TextStyle(
                          color: AppColors.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.registerScreen);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
