import 'package:chat_app/presentations/edit_profile/edit_profile_controller.dart';
import 'package:chat_app/widget/app_button.dart';
import 'package:chat_app/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final EditProfileController _con = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
          ),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.accentColor,
      ),
      body: Obx(
        () => _con.isLoading.value
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: AppColors.accentColor,
                  strokeWidth: 5,
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  AppTextFiled(
                    hintText: "First name",
                    initalValue: _con.firstName.value,
                    errorMessage: _con.firstNameError,
                    onChanged: (v) => _con.firstName.value = v,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFiled(
                    hintText: "Last name",
                    initalValue: _con.lastName.value,
                    errorMessage: _con.lastNameError,
                    onChanged: (v) => _con.lastName.value = v,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppTextFiled(
                    hintText: "Email",
                    errorMessage: "".obs,
                    initalValue: _con.email.value,
                    onChanged: (v) => _con.email.value = v,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    onPressed: () {
                      if (_con.validation()) {
                        _con.updateUserData();
                      }
                    },
                    text: "Update",
                    isLoading: _con.isUpdateLoading,
                  )
                ],
              ),
      ),
    );
  }
}
