import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

appBar({
  Widget? leading,
  required String title,
  List<Widget>? actions,
}) =>
    AppBar(
      centerTitle: true,
      elevation: 0,
      leading: leading ??
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.whiteColor,
            ),
          ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.whiteColor,
        ),
      ),
      actions: actions,
      backgroundColor: AppColors.accentColor,
    );
