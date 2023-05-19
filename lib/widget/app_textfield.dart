import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextFiled extends StatelessWidget {
  final String hintText;
  final RxString errorMessage;
  final bool obscureText;
  final Function(String) onChanged;

  const AppTextFiled({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.errorMessage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.accentColor,
              width: 2,
            ),
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            onChanged: onChanged,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: hintText,
            ),
          ),
        ),
        Obx(
          () => errorMessage.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "*${errorMessage.value}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
