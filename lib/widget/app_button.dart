import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double? width;
  final RxBool isLoading;
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed,
        child: Obx(
          () => Container(
            alignment: Alignment.center,
            height: 50,
            width: Get.width,
            child: isLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                      strokeWidth: 5,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
